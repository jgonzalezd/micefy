module Versions
  module Version2
    module Resources
      class Announces < Grape::API
        resource :announces do
          helpers Versions::Version2::Helpers::Authentication
          desc "Announces end point"
          get do
            authenticate!
            event_user = api_current_user.event_users.find_by(checkin: true)
            if event_user.present?
              event = event_user.event
              announces = event.announces.page(params[:page]).per(params[:limit])
            else
              announces = Announce.none
            end
            present announces, with: Versions::Version2::Entities::Announces
          end

          params do
            requires :content, type: String
          end
          post do
            authenticate!
            event_user = api_current_user.event_users.find_by(checkin: true)
            if event_user.present?
              event = event_user.event
              announce = event.announces.new(declared(params))
              announce.user_id = api_current_user.id
              announce.save
            else
              announce = Announce.new(declared(params))
              announce.user_id = api_current_user.id
              announce.valid?
            end
            present announce, with: Versions::Version2::Entities::Announces
          end
          route_param :id do
            put do
              authenticate!
              event_user = api_current_user.event_users.find_by(checkin: true)
              if event_user.present?
                event = event_user.event
                announce = event.announces.find(params[:id])
                announce.update_attributes(declared(params))
              else
                announce = Announce.new(declared(params))
                announce.user_id = api_current_user.id
                announce.valid?
              end
              present announce, with: Versions::Version2::Entities::Announces
            end
            delete do
              authenticate!
              event_user = api_current_user.event_users.find_by(checkin: true)
              if event_user.present?
                event = event_user.event
                announce = event.announces.find(params[:id])
                announce.destroy
              else
                announce = Announce.new(declared(params))
                announce.user_id = api_current_user.id
                announce.valid?
              end
              present announce, with: Versions::Version2::Entities::Announces
            end
          end

        end
      end
    end
  end
end
