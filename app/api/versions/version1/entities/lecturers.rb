module Versions
  module Version1
    module Entities
      class Lecturers < Grape::Entity
        expose :name
        expose :country, using: Versions::Version1::Entities::Countries
      end
    end
  end
end

