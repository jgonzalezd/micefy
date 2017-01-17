module Versions
  module Version1
    module Entities
      class Questions < Grape::Entity
        format_with(:default) {|dt| dt.to_s :default}
        expose :id
        expose :content
        expose :user_id
        expose :by do |question, options|
          question.user.name
        end
        expose :owned do |question, options|
          question.user_id == options[:user].id
        end
        expose :votes_for do |question, options|
          question.votes_for.to_s
        end
        expose :voted do |question, options|
          options[:user].voted_for?(question)
        end
        with_options(format_with: :default) do
          expose :created_at
          expose :updated_at
        end
      end
    end
  end
end
