module Versions
  module Version2
    module Resources
      class Events < Grape::API
        resource :events do
          helpers Versions::Version2::Helpers::Authentication
          desc "Events point"
          get do
            authenticate!
            eventArel = Event.arel_table
            query = params[:query] + "%" || ""
            events = Event.where(eventArel[:name].matches(query)).page(params[:page]).per(params[:limit])
            present events, with: Versions::Version2::Entities::Events, user: api_current_user
          end
          route_param :id do
            post :subscribe do
              authenticate!
              event = Event.find(params[:id])
              event_user = event.event_users.find_or_initialize_by(:user_id => api_current_user.id)
              if event_user.new_record?
                event_user.save
              else
                event_user.destroy
              end
              present event, with: Versions::Version2::Entities::Events, user: api_current_user
            end
            post :checkin do
              authenticate!
              event = Event.find(params[:id])
              checked_events = EventUser.where(:user_id => api_current_user.id, checkin: true)
              checked_events.update_all(checkin: false)
              if params[:checked]
                event_user = event.event_users.find_or_initialize_by(:user_id => api_current_user.id)
                event_user.checkin = true
                event_user.save
              end
              present event, with: Versions::Version2::Entities::Events, user: api_current_user
            end
          end
        end
      end
    end
  end
end
