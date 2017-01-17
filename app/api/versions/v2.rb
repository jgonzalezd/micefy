module Versions
  class V2 < Grape::API
    version 'v2', :using => :path
    format :json
    mount Versions::Version2::Resources::Registrations
    mount Versions::Version2::Resources::Sessions
    mount Versions::Version2::Resources::Events
    mount Versions::Version2::Resources::Conferences
    mount Versions::Version2::Resources::Questions
    mount Versions::Version2::Resources::Notes
    mount Versions::Version2::Resources::Slides
    mount Versions::Version2::Resources::Networking
    mount Versions::Version2::Resources::Announces
    mount Versions::Version2::Resources::Conversations
    mount Versions::Version2::Resources::Messages
    mount Versions::Version2::Resources::Pusher
  end
end
