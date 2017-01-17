module Versions
  module Version2
    module Resources
      class Networking < Grape::API
        resource :networking do
          helpers Versions::Version2::Helpers::Authentication

          desc "Networking point"

          get :attendants do
            authenticate!
            event_user = api_current_user.event_users.find_by(checkin: true)
            if event_user.present?
              event = event_user.event
              users = event.attending_users.where.not(id: api_current_user.id).page(params[:page]).per(params[:limit])
            else
              users = User.none
            end
            present users, with: Versions::Version2::Entities::Users
          end

          get :suggested do
            authenticate!
            event_user = api_current_user.event_users.find_by(checkin: true)
            if event_user.present?
              event = event_user.event
              users = event.attending_users.where.not(id: api_current_user.id).tagged_with(api_current_user.interest_list, on: :interests, any: true).page(params[:page]).per(params[:limit])
            else
              users = User.none
            end
            present users, with: Versions::Version2::Entities::Users
          end
        end
      end
    end
  end
end
