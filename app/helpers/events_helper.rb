module EventsHelper

	def insert_date_of (conference, message_4_missing)
		Time.use_zone(conference.event.timezone) do
			context = 'views.organizers.events.show'
			return message_4_missing unless conference.start_at.in_time_zone.present?

			days_of_difference = (conference.start_at.day-conference.end_at.day) / 1.day
			if days_of_difference == 0
				return t("#{context}.conferences_list.date.days", :count => days_of_difference,
	              start_time: l(conference.start_at.in_time_zone, format: :conference_start_time_same_day),
	              end_time: l(conference.end_at.in_time_zone, format: :conference_end_time_same_day))
			else
				return t("#{context}.conferences_list.date.days", :count => days_of_difference,
	              start_time: l(conference.start_at.in_time_zone, format: :conference_start_time_different_day),
	              end_time: l(conference.end_at.in_time_zone, format: :conference_end_time_different_day))
			end
		end unless (conference.start_at.blank? || conference.end_at.blank?)
	end

  def filter_active_tab(value)
    return "active" if (value === "drafts" && params[:filter].blank?) || value === params[:filter]
  end
end
