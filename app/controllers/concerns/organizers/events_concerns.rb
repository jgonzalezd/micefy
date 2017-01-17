module Organizers::EventsConcerns
  extend ActiveSupport::Concern

  # This module is created in order to de-couple ROR from the business logic, making this easier to modify and organize

  # create event

  def create_event(organizer, event_params)
    event = organizer.events.new(event_params)
    event.process_timezone.save
    event
  end

  # update event
  def publish_or_unpublish(event, publish_signal, publish_token)
    case publish_signal
      when "publish"
        return publish_event(event, publish_token) if event.may_publish?
      when "unpublish"
        return unpublish_event(event) if event.may_unpublish?
      else
        return [:error, :unknown_action]
    end
  end

  def update_event(event, event_params)
    event.assign_attributes(event_params)
    if event.process_timezone.save
      location = event.locations.first
      if event_params[:set_location_to_all_confs] == "true"
        new_location_id = location.nil? ? nil : location.id
        event.conferences.update_all location_id: new_location_id
      end
      [:notice, :updated]
    else
      [:error, :not_updated]
    end
  end

  def publish_event(event, token)
    event_code = EventCode.find_by_token(token)
    if event_code.present? && event_code.active?
      ActiveRecord::Base.transaction do # It is perfectly fine to mix model types inside a single transaction block. This is because the transaction is bound to the database connection not the model instance.
        if event_code.event_id.present?
          return [:error, :code_already_used] if event_code.event_id != event.id
        else
          event_code.event_id = event.id
        end
        Time.use_zone(event.timezone) { event.publish! }
        event_code.deactivate!
        return [:notice, :published]
      end
    else
      [:error, :invalid_token]
    end
  end

  def unpublish_event(event)
    event_code = EventCode.find_by_event_id(event.id)
    if event_code.present? && event_code.inactive?
      ActiveRecord::Base.transaction do # Reffer to comment in publish_event
        Time.use_zone(event.timezone) { event.unpublish! }
        event_code.activate!
        return [:notice, :unpublished]
      end
    else
      [:error, :invalid_token]
    end
  end
end
