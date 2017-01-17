module Versions
  module Version1
    module Entities
      class Conferences < Grape::Entity
        format_with(:default) {|dt| dt.try(:to_s, :default)}
        format_with(:time) {|dt| dt.try(:strftime, '%I:%M %P')}
        format_with(:date) {|dt| dt.try(:strftime, '%A, %b %d')}
        expose :id
        expose :name
        expose :description
        expose :embedded_url
        expose :location_name do |conference, options|
          conference.location.try(:name) || ""
        end
        with_options(format_with: :default) do
          expose :start_at do |conference, options|
            I18n.l(conference.start_at.in_time_zone(conference.event.timezone || "UTC"), format: :short)
          end
          expose :end_at do |conference, options|
            I18n.l(conference.end_at.in_time_zone(conference.event.timezone || "UTC"), format: :short)
          end
          expose :created_at
          expose :updated_at
        end

        expose :start_at_time do |conference, options|
          I18n.l(conference.start_at.in_time_zone(conference.event.timezone || "UTC"), format: '%I:%M %P')
        end
        expose :end_at_time do |conference, options|
          I18n.l(conference.end_at.in_time_zone(conference.event.timezone || "UTC"), format: '%I:%M %P')
        end

        expose :start_date do |conference, options|
          I18n.l(conference.start_date.in_time_zone(conference.event.timezone || "UTC"), format: '%A, %b %d')
        end

        expose :lecturers, using: Versions::Version1::Entities::Lecturers
        expose :location, using: Versions::Version1::Entities::Locations
        expose :started, if: lambda { |conference, options| conference.start_at.present? } do |conference, options|
          conference.start_at <= Time.zone.now && conference.end_at.present? && conference.end_at > Time.zone.now
        end
        expose :ended, if: lambda { |conference, options| conference.end_at.present? } do |conference, options|
          conference.end_at <= Time.zone.now
        end
      end
    end
  end
end
