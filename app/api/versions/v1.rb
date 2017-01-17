module Versions
  class V1 < Grape::API
    version 'v1', :using => :path
    format :json
    mount Versions::Version1::Resources::Events
    mount Versions::Version1::Resources::Users
    mount Versions::Version1::Resources::Conferences
    mount Versions::Version1::Resources::Notifications
    mount Versions::Version1::Resources::Pusher
    mount Versions::Version1::Resources::Users
    mount Versions::Version1::Resources::Microposts
    mount Versions::Version1::Resources::Questions
    mount Versions::Version1::Resources::Notes
    mount Versions::Version1::Resources::Chatrooms
  	mount Versions::Version1::Resources::Interests
  end
end
