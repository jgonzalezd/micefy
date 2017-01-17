module Versions
  module Version2
    module Entities
      class Users < Grape::Entity
        expose :id
        expose :contact_email
        expose :name
        expose :position
        expose :company
        expose :interest_list
        expose :authentication_token, if: lambda { |instance, options| options[:authentication_token] }
        expose :event, if: lambda { |instance, options| options[:event] }, using: Versions::Version2::Entities::Events do |instance, options|
          Event.joins(:event_users).where(:"event_users.user_id" => instance.id, :"event_users.checkin" => true).first
        end
      end
    end
  end
end
