module Versions
  module Version1
    module Resources
      class Conferences < Grape::API
        resource :conferences do
          params do
            optional :page, type: Integer, default: 1, desc: "Page."
            optional :limit, type: Integer, default: 10, desc: "Quantity."
            optional :conditions, type: Hash, default: {}, desc: "Conditions."
          end
          get do
            event = Event.find(params[:event_id])
            conditions = params[:conditions] || {}
            conferences = event.conferences.select("conferences.*, conferences.start_at AS start_date").includes(:lecturers).order(:start_at).where(conditions.merge({archived: false}).to_h).page(params[:page]).per(params[:limit])
            present conferences, with: Versions::Version1::Entities::Conferences
          end
          get :extended do
            event = Event.find(params[:event_id])
            conferences = event.conferences.order(:start_at).page(params[:page]).per(params[:limit])
            current = conferences.select {|conference| conference.start_at <= Time.zone.now && conference.end_at > Time.zone.now }
            past = conferences.select {|conference| conference.end_at.present? && conference.end_at <= Time.zone.now }
            future = conferences.select {|conference| conference.start_at.present? && conference.start_at > Time.zone.now }
            response_object = Hashie::Mash.new({:current => current, 'past' => past, 'future' => future})
            present response_object, with: Versions::Version1::Entities::ConferencesExtended
          end
          get :slides do
            conference = Conference.find(params[:conference_id])
            current_slide = conference.slides.find_by(number: conference.current_step)
            {current_slide: current_slide.try(:code) || 0, slides: conference.slides.collect {|s| {code: s.code, storage_url: s.storage_url}}}
          end

          get 'slides/current' do
            conference = Conference.find(params[:conference_id])
            current_slide = conference.slides.find_by(number: conference.current_step)
            {code: current_slide.try(:code) || 0}
          end
        end
      end
    end
  end
end
