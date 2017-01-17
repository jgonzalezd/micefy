module Versions
  module Version2
    module Entities
      class OauthErrors < Grape::Entity
        expose :errors do |instance, options|
          #instance.errors.messages.values.collect {|value| {field: value[0].translation_metadata}
          errors = []
          instance.errors.messages.each do |key, messages|
            messages.each do |message|
              if message.is_a? Symbol
                error = message                
              else
                metadata = message.translation_metadata
                error = metadata[:key].to_s.split(".").last
              end
              errors.push "oauth.#{key}.#{error}"
            end
          end
          errors
        end
      end
    end
  end
end
