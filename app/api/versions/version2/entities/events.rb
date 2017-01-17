module Versions
  module Version2
    module Entities
      class Events < Grape::Entity
        expose :id
        expose :name
        expose :storage_url
        expose :description
        expose :start_at
        expose :end_at
        expose :conferences, using: Versions::Version2::Entities::Conferences
        expose :subscribed, if: lambda {|instance, options| options[:user]} do |event, options|
          event.event_users.where(user_id: options[:user].id).any?
        end
        expose :checked, if: lambda {|instance, options| options[:user]} do |event, options|
          event.event_users.where(user_id: options[:user].id, checkin: true).any?
        end
      end
    end
  end
end
