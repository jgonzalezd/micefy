module Versions
  module Version1
    module Helpers
      module Authentication
        def authenticate!
          error!('Unauthorized. Invalid or expired token.', 401) unless api_current_user
        end

        def api_current_user
          # find user by token
          @current_user = User.find_by(:authentication_token => params[:auth_token])
        end
      end
    end
  end
end
