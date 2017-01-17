module Versions
  module Version2
    module Entities
      class Conversations < Grape::Entity
        expose :id do |conversation, options|
          conversation[:room]
        end
        expose :users, using: Versions::Version2::Entities::Users do |conversation, options|
          User.where(id: conversation[:user])
        end
      end
    end
  end
end
