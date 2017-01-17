class QuestionsController < ApplicationController
  respond_to :html
  respond_to :json

  def index
    @event = Event.find_by_token params[:token]
    respond_with @event do |format|
      format.html do
        @conferences = @event.conferences
        render
      end
      format.json do
        @conference = @event.conferences.find params[:conference_id]
        questions = @conference.questions.tally
        render json: questions
      end
    end
  end

end
