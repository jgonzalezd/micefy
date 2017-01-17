module Versions
  module Version1
    module Entities
      class Events < Grape::Entity
        format_with(:default) {|dt| dt.blank? ? "" : dt.to_s(:default)}
        expose :id
        expose :name
        expose :storage_url
        expose :map_picture_url
        expose :in_time do |event, options|
          event.in_time?(Time.zone.now)
        end
        expose :map_picture do |event, options|
          event.map_picture.present?
        end
        expose :description
        with_options(format_with: :default) do
          expose :start_at do |event, options|
            I18n.l(event.start_at.in_time_zone(event.timezone || "UTC"), format: :short)
          end
          expose :end_at do |event, options|
            I18n.l(event.end_at.in_time_zone(event.timezone || "UTC"), format: :short)
          end
          expose :created_at
          expose :updated_at
        end
        expose :indications, using: Versions::Version1::Entities::Indications
        expose :locations, using: Versions::Version1::Entities::Locations
        expose :rsvp do |event, options|
          if options[:user].present?
            event_user = event.attending.where(user_id: options[:user].id).first
            event_user && event_user.rsvp.present? ? event_user.rsvp : "no"
          else
            "yes"
          end
        end
        expose :attending do |event, options|
          if options[:user].present?
            event_user = event.attending.where(user_id: options[:user].id).first
            event_user.present?
          else
            true
          end
        end
        expose :checkeable do |event, options|
          if options[:user].present?
            event_user = event.attending.where(user_id: options[:user].id).first
            event_user.present? && event.in_time?(Time.zone.now)
          else
            false
          end
        end
        expose :checked do |event, options|
          if options[:user].present?
            checkin = event.attendees.where(user_id: options[:user].id).first
            checkin.present?
          else
            true
          end
        end
      end
    end
  end
end
