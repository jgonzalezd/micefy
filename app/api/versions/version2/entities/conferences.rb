module Versions
  module Version2
    module Entities
      class Conferences < Grape::Entity
        expose :id
        expose :name
        expose :description
        expose :start_at
        expose :end_at
      end
    end
  end
end
