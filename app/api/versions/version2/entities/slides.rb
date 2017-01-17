module Versions
  module Version2
    module Entities
      class Slides < Grape::Entity
        expose :code
        expose :storage_url do |slide, options|
          slide.storage_url
        end
      end
    end
  end
end
