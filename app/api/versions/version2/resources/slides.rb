module Versions
  module Version2
    module Resources
      class Slides < Grape::API
        resource :slides do
          helpers Versions::Version2::Helpers::Authentication
          desc "Slides point"
          get do
            authenticate!
            event = Event.find(params[:event_id])
            conference = event.conferences.find(params[:conference_id])
            present conference, with: Versions::Version2::Entities::ConferenceSlides
          end

          post :notify do
            conference = Conference.find_by({id: params[:conference_id], security_hash: params[:conference_hash]})
            if conference.present?
              case params[:event]
              when 'option'
                conference.update_attribute :current_step, params[:option]
              end
              ::Pusher.trigger("conference-#{conference.id}-presentation", "slide-change", {current_slide: conference.current_step})
            else
              {message: :invalid_data}
            end
          end
        end
      end
    end
  end
end
