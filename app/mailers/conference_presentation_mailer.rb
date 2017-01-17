class ConferencePresentationMailer < ActionMailer::Base
  default from: "contact@micefy.com"

  def notification_on_new_presentation(conference, old_presentation)
  	@conference = conference
  	@old_presentation = old_presentation
  	mail to: ["brayancastrop@gmail.com", "jgonzalezd.sist@gmail.com"]
  end
end
