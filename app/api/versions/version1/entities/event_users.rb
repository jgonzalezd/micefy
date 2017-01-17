module Versions
  module Version1
    module Entities
      class EventUsers < Grape::Entity
        expose :id
        expose :checkin
        expose :rsvp
        expose :event, using: Versions::Version1::Entities::Events
      end
    end
  end
end
