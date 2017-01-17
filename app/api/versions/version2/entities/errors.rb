module Versions
  module Version2
    module Entities
      class Errors < Grape::Entity
        expose :errors do |instance, options|
          #instance.errors.messages.values.collect {|value| {field: value[0].translation_metadata}
          errors = {}
          instance.errors.messages.each do |key, messages|
            errors[key] = []
            messages.each do |message|
              metadata = message.translation_metadata
              error = metadata[:key].to_s.split(".").last
              errors[key].push error
            end
          end
          errors
        end
      end
    end
  end
end
