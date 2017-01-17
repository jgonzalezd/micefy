module Versions
  module Version1
    module Entities
      class ConferencesExtended < Grape::Entity
        expose :current, using: Versions::Version1::Entities::Conferences
        expose :past, using: Versions::Version1::Entities::Conferences
        expose :future, using: Versions::Version1::Entities::Conferences
      end
    end
  end
end
