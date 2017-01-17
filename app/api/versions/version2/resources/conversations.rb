module Versions
  module Version2
    module Resources
      class Conversations < Grape::API
        resource :conversations do
          helpers Versions::Version2::Helpers::Authentication
          helpers Versions::Version2::Helpers::Conversations

          desc "Conversations end point"
          get do
            authenticate!
            conversations = paginated_conversations(api_current_user.id)
            present conversations, with: Versions::Version2::Entities::Conversations, user: api_current_user
          end
        end
      end
    end
  end
end
