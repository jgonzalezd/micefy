module Versions
  module Version2
    module Entities
      class ConferenceSlides < Grape::Entity
        expose :current_step, as: :current_slide
        expose :slides, using: Versions::Version2::Entities::Slides
      end
    end
  end
end
