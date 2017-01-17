module Versions
  module Version2
    module Resources
      class Conferences < Grape::API
        resource :conferences do
          helpers Versions::Version2::Helpers::Authentication
          desc "Conferences point"
          get do
            authenticate!
            event = Event.find(params[:event_id])
            conferences = event.conferences.order(:start_at).where(archived: false).page(params[:page]).per(params[:limit])
            present conferences, with: Versions::Version2::Entities::Conferences
          end
        end
      end
    end
  end
end
