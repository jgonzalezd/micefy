module Versions
  module Version1
    module Resources
      class Users < Grape::API
        resource :users do
          helpers Versions::Version1::Helpers::Authentication

          desc "Authenticate and return authentication token"
          params do
            #requires :username, :type => String, :desc => "Username"
            #requires :password, :type => String, :desc => "Password"
          end
          get do
            event = Event.find(params[:event_id])
            attendees = event.attendees.where.not(id: api_current_user.id)
            present attendees, with: Versions::Version1::Entities::Users, current_user: false
          end
          post :auth do
            user = User.find_for_database_authentication({:email => params[:email]})
            if user && user.valid_password?(params[:password])
              user.ensure_authentication_token
              user.save
              present user, with: Versions::Version1::Entities::Users, current_user: true, user: user
            else
              {message: :"users.sign_in.invalid_credentials"}
            end
          end
          post :register do
            user = User.new params.select {|key, value| ['name', 'email', 'password'].include?(key)}
            user.ensure_authentication_token
            if user.save
              present user, with: Versions::Version1::Entities::Users, current_user: true
            else
              # {message: user.errors.full_messages.to_sentence}
              {message: user.errors.full_messages.map(&:parameterize).map(&:underscore)}
            end
          end
          post :token do
            present api_current_user, with: Versions::Version1::Entities::Users, current_user: true, user: api_current_user
          end
          get :show do
            present api_current_user, with: Versions::Version1::Entities::Users, current_user: true
          end
          post :update do
            attributes = params.select {|key, value| ['contact_email', 'name', 'position', 'company'].include?(key) }
            u = api_current_user # For some reason this is needed to make work tags
            u.interest_list = params[:interests]
            u.update_attributes(attributes)
            u.save
            present u, with: Versions::Version1::Entities::Users, current_user: true
          end
          get :info do
            user = User.find params[:id]
            present user, with: Versions::Version1::Entities::Users, current_user: false
          end
        end
      end
    end
  end
end
