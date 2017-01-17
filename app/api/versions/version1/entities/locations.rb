module Versions
  module Version1
    module Entities
      class Locations < Grape::Entity
        expose :name
        expose :address
        expose :latitude
        expose :longitude
      end
    end
  end
end
