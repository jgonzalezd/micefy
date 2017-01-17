module Versions
  module Version1
    module Resources
      class Notifications < Grape::API
        resource :notifications do
          desc "Send conference notifications"
          params do
            #requires :username, :type => String, :desc => "Username"
            #requires :password, :type => String, :desc => "Password"
          end
          post :notify do
            conference = Conference.find_by({id: params[:conference_id], security_hash: params[:conference_hash]})
            if conference.present?
              case params[:event]
              when 'previous'
                conference.decrement!(:current_step)
              when 'next'
                conference.increment!(:current_step)
              when 'start'
                conference.update_attribute :current_step, 1
              when 'option'
                conference.update_attribute :current_step, params[:option]
              end
              current_slide = conference.slides.find_by(number: conference.current_step)
              ::Pusher.trigger("conference-#{conference.id}", "slide-change", {current_slide: current_slide.code})
            else
              {message: "Invalid Data"}
            end
          end
        end
      end
    end
  end
end
