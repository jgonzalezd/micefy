module Versions
  module Version1
    module Entities
      class Indications < Grape::Entity
        expose :id
        expose :content
        expose :kind_class do |indication, options|
          lungo_classes = {information: "accept", warning: "warning", regulatory: "cancel"}
          key = indication.kind.to_sym
          lungo_classes[key]
        end
      end
    end
  end
end
