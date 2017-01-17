module ConferenceConcern
  extend ActiveSupport::Concern
  included do
    before_validation :process_timezone
    around_create :checkn_mail_when_new_presentation
    around_update :checkn_mail_when_new_presentation
  end

  def process_timezone
    self.start_at = Time.use_zone(self.event.timezone) { Time.zone.local_to_utc(self.start_at) } if (self.event.timezone.present? && self.start_at.present?)
    self.end_at = Time.use_zone(self.event.timezone) { Time.zone.local_to_utc(self.end_at) } if (self.event.timezone.present? && self.end_at.present?)
  end

  def checkn_mail_when_new_presentation
  	old_presentation = nil
  	send_email_flag = false
    if embedded_url.present?
    	if new_record?
    		send_email_flag = true
    	else 
    		send_email_flag = true if embedded_url_changed? 
    		old_presentation = embedded_url_was
    	end
    end
  	yield
  	notify_on_new_presentation(old_presentation) if send_email_flag
  end
end