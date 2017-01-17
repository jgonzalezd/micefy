module Versions
  module Version1
    module Resources
      class Pusher < Grape::API
        resource :pusher do
          desc "Pusher auth"
          params do
            #requires :username, :type => String, :desc => "Username"
            #requires :password, :type => String, :desc => "Password"
          end
          post :auth do
            status 200
            ::Pusher[params[:channel_name]].authenticate(params[:socket_id])
          end
        end
      end
    end
  end
end
