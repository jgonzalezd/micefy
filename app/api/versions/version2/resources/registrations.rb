module Versions
  module Version2
    module Resources
      class Registrations < Grape::API
        resource :registrations do
          helpers Versions::Version2::Helpers::Authentication
          helpers Versions::Version2::Helpers::Oauth

          rescue_from FbGraph::Auth::VerificationFailed do |e|
            rack_response({errors: "oauth." + e.message.downcase.gsub(" ", "_")}.to_json, e.status)
          end

          desc "User registration point"
          post do
            user = User.new params[:user]
            user.ensure_authentication_token
            if user.save
              present user, with: Versions::Version2::Entities::Users, authentication_token: true, event: true
            else
              status 422
              present user, with: Versions::Version2::Entities::Errors
            end
          end

          params do
            requires :name, type: String
            optional :position, type: String
            optional :company, type: String
            optional :interest_list
          end
          put do
            authenticate!
            user = api_current_user
            if user.update_attributes(declared(params))
              present user, with: Versions::Version2::Entities::Users, authentication_token: true, event: true
            else
              status 422
              present user, with: Versions::Version2::Entities::Errors
            end
          end

          post :oauth do
            case params[:provider]
            when "facebook"
              data = facebook(params[:authResponse])
              # data.picture(:large)  # retrieves user picture
              password = SecureRandom.hex(Devise.password_length.begin)
              user_params = {
                name: data.name,
                email: data.email,
                password: password,
                password_confirmation: password
              }
              identity_params = {
                provider: params[:provider],
                uid: data.identifier
              }
              user = User.new user_params
              user.identities.new identity_params
              user.ensure_authentication_token
              if user.save
                present user, with: Versions::Version2::Entities::Users, authentication_token: true, event: true
              else
                status 422
                present user, with: Versions::Version2::Entities::OauthErrors
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
