module Versions
  module Version1
    module Resources
      class Events < Grape::API
        resource :events do
          helpers Versions::Version1::Helpers::Authentication
          params do
            optional :page, type: Integer, default: 1, desc: "Page."
            optional :limit, type: Integer, default: 10, desc: "Quantity."
            optional :conditions, type: Hash, default: {}, desc: "Conditions."
          end
          get do
            authenticate!
            events = api_current_user.events.where(params[:conditions]).page(params[:page]).per(params[:limit])
            present events, with: Versions::Version1::Entities::Events, user: api_current_user
          end
          get :subscribed do
            authenticate!
            present api_current_user.subscribed_events.page(params[:page]).per(params[:limit]), with: Versions::Version1::Entities::Events, user: api_current_user
          end
          get :suggested do
            authenticate!
            present api_current_user.suggested_events.page(params[:page]).per(params[:limit]), with: Versions::Version1::Entities::Events, user: api_current_user
          end
          get :search do
            authenticate!
            arel_events = Arel::Table.new(:events)
            events = Event.where(arel_events[:name].matches("%#{params[:q]}%")).page(params[:page]).per(params[:limit])
            present events, with: Versions::Version1::Entities::Events, user: api_current_user
          end
          post :rsvp do
            authenticate!
            event = Event.find(params[:id])
            event_user = event.event_users.find_or_create_by(:user_id => api_current_user.id)
            event_user.update_attribute(:rsvp, params[:rsvp])
            present event, with: Versions::Version1::Entities::Events, user: api_current_user
          end
          post :check do
            authenticate!
            event = Event.find(params[:id])
            event_user = event.event_users.find_or_create_by(:user_id => api_current_user.id)
            event_user.update_attributes(checkin: params[:checkin], rsvp: 'yes')
            present event, with: Versions::Version1::Entities::Events, user: api_current_user
          end
          get :'users/all' do
            authenticate!
            event = Event.find(params[:event_id])
            attendees = event.attendees_users.where.not(id: api_current_user.id)
            present attendees, with: Versions::Version1::Entities::Users, type: :partial
          end
          get :'users/suggested' do
            authenticate!
            event = Event.find(params[:event_id])
            interests = api_current_user.interest_list
            attendees = event.attendees_users.where.not(id: api_current_user.id).tagged_with(interests, on: :interests, any: true) #filter by interests
            present attendees, with: Versions::Version1::Entities::Users, type: :partial
          end
          get :'posts' do
            authenticate!
            event = Event.find(params[:event_id])
            present([{
              content: "Hi Guys, looking for friends, i'm forever alone :(",
              sender: api_current_user
            }])
          end
        end
      end
    end
  end
end
