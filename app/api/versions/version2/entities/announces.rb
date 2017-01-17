module Versions
  module Version2
    module Entities
      class Announces < Grape::Entity
        expose :id
        expose :content
        expose :created_at
        expose :user, using: Versions::Version2::Entities::Users
      end
    end
  end
end
