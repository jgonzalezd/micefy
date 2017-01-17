class Organizers::RegistrationsController < Devise::RegistrationsController

  protected

    def after_update_path_for(resource)
      organizers_events_path
    end

end
