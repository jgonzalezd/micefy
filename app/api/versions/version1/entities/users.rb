module Versions
  module Version1
    module Entities
      class Users < Grape::Entity
        expose :id
        expose :contact_email
        expose :name
        expose :position
        expose :company
        expose :interest_list
        expose :authentication_token, as: :auth_token, if: lambda { |instance, options| options[:current_user] }
        expose :attending_event, unless: lambda { |instance, options| options[:type] == :partial }, using: Versions::Version1::Entities::EventUsers
      end
    end
  end
end
