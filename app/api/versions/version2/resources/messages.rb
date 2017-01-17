module Versions
  module Version2
    module Resources
      class Messages < Grape::API
        resource :messages do
          helpers Versions::Version2::Helpers::Authentication
          helpers Versions::Version2::Helpers::Messages

          desc "Messages end point"
          get do
            authenticate!
            messages = paginated_messages(api_current_user.id, params[:user_id], params[:last_message_id])
            present messages, with: Versions::Version2::Entities::Messages
          end

          post do
            authenticate!
            message = create_message(api_current_user.id, api_current_user.name, params[:user_id], params[:content])
            present message, with: Versions::Version2::Entities::Messages
          end
        end
      end
    end
  end
end
