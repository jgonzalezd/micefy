module Versions
  module Version2
    module Entities
      class Messages < Grape::Entity
        expose :user_id do |instance, options|
        	instance[:sender]
        end
        expose :content do |instance, options|
        	instance[:content]
        end
        expose :timestamp do |instance, options|
        	instance[:timestamp]
        end
      end
    end
  end
end
