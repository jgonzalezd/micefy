RailsAdmin.config do |config|
  Rails.logger.info "Rails Admin need to whitelist models in order to avoid this issue - https://github.com/sferik/rails_admin/issues/1697" if Rails.env.development?
  config.included_models = ["Admin", "Conference", "Country", "Event", "EventCode", "EventUser", "Lecturer", "Location", "Organizer", "User", "Slide", "Question"]
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method &:current_admin
end
