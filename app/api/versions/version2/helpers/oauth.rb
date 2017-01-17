module Versions
  module Version2
    module Helpers
      module Oauth
        
        def facebook(options)
          data = FbGraph::Auth::SignedRequest.verify(FBAuth.client, options[:signedRequest])
          if data[:user_id] == options[:userID]
            access_token = options[:accessToken]
            user = FbGraph::User.new(data[:user_id], access_token: access_token)
            user = user.fetch
            if data[:user_id] == user.identifier.to_s
              user
            else
              {errors: :invalid_signed_request}
            end
          else
            {errors: :invalid_signed_request}
          end
        end

        def linkedin(options)
          
        end

      end
    end
  end
end
