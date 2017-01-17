module Versions
  module Version2
    module Entities
      class Notes < Grape::Entity
        expose :id
        expose :content
        expose :created_at
        expose :updated_at
        expose :user, using: Versions::Version2::Entities::Users
      end
    end
  end
end
