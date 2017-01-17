module Versions
  module Version1
    module Resources
      class Microposts < Grape::API
        resource :microposts do
          helpers Versions::Version1::Helpers::Authentication
          desc "manage conference announcements"
          params do
          end
          post do
            authenticate!
            micropost = Micropost.create(api_current_user.id, params[:event_id],params[:content])
            begin
              #::Pusher.trigger("user-#{params[:receiver_id]}", "message-new", {sender_id: api_current_user.id, name: api_current_user.name })
            rescue Exception => e
              puts "[ERROR]: Unable to deliver message to receiver due to an error in Pusher:\n #{e}"
            end
            micropost
          end
          get do
            authenticate!
            Micropost.get_all(params[:event_id])
          end
        end
      end
    end
  end
end
