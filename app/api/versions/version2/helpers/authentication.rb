module Versions
  module Version2
    module Helpers
      module Authentication
        include ActionController::HttpAuthentication::Token
        def authenticate!
          error!('Unauthorized. Invalid or expired token.', 401) unless api_current_user
        end

        def api_current_user
          # find user by token
          token, options = grape_token_and_options(headers["Authorization"])
          @current_user = User.find_by(:authentication_token => token)
        end

        private

        def grape_token_and_options(authorization)
          if authorization[TOKEN_REGEX]
            params = token_params_from(authorization)
            [params.shift[1], Hash[params].with_indifferent_access]
          end
        end
      end
    end
  end
end
