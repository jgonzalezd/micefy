module Versions
  module Version2
    module Entities
      class Questions < Grape::Entity
        expose :id
        expose :content
        expose :user, using: Versions::Version2::Entities::Users
        expose :votes_count do |question, options|
          question.votes_for
        end
        expose :voted do |question, options|
          options[:user].voted_for?(question)
        end
        expose :created_at
        expose :updated_at
      end
    end
  end
end
