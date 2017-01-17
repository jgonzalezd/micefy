class EventCodeRequestMailer < ActionMailer::Base
  default from: "contact@micefy.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.event_code_request_mailer.new_request.subject
  #
  def new_request(organizer)
    @greeting = "Hi"
    @organizer = organizer
    mail to: ["brayancastrop@gmail.com", "jgonzalezd.sist@gmail.com"]
  end
end
