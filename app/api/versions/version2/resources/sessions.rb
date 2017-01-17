module Versions
  module Version2
    module Resources
      class Sessions < Grape::API
        resource :sessions do
          helpers Versions::Version2::Helpers::Authentication
          helpers Versions::Version2::Helpers::Oauth

          rescue_from FbGraph::Auth::VerificationFailed do |e|
            rack_response({errors: "oauth." + e.message.downcase.gsub(" ", "_")}.to_json, e.status)
          end

          desc "User authentication point"

          get :show do
            authenticate!
            user = api_current_user
            present user, with: Versions::Version2::Entities::Users, authentication_token: true, event: true
          end

          post do
            _user_params = params[:user]
            user = User.find_for_database_authentication({:email => _user_params[:email] })
            if user && user.valid_password?(_user_params[:password])
              user.ensure_authentication_token
              user.save
              present user, with: Versions::Version2::Entities::Users, authentication_token: true, event: true
            else
              status 422
              {errors: :invalid_credentials}
            end
          end

          post :oauth do
            case params[:provider]
            when "facebook"
              data = facebook(params[:authResponse])
              user = User.find_for_oauth_authentication({uid: data.identifier, provider: params[:provider]})
              if user.present?
                present user, with: Versions::Version2::Entities::Users, authentication_token: true, event: true
              else
                status 422
                resp = Hashie::Mash.new({errors: {messages: {user: [:not_registered]}}})
                present(resp, with: Versions::Version2::Entities::OauthErrors)
              end
            when "linkedin"
              {}
            else
              {}
            end
          end
        end
      end
    end
  end
end
