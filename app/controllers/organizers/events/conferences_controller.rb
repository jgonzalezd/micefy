class Organizers::Events::ConferencesController < ApplicationController
  before_filter :authenticate_organizer!
  before_action :set_conference, only: [:show, :edit, :update, :destroy, :present]
  before_action :set_event, only: [:new, :create]

  def new
    @conference = @event.conferences.new
    @locations  = @event.locations
    @conference.lecturers.build
    @countries = Country.all
  end

  def create
    @conference = @event.conferences.new(conference_params)
    unless @conference.archived
      if @conference.dates_not_set?
        @conference.archived = true
      end
    end
    respond_to do |format|
      if @conference.save #internally localize the dates in model concern
        format.html { redirect_to organizers_conference_path(@conference), success: 'Conference was successfully created.' }
        format.json { render action: 'show', status: :created, location: @conference }
      else
        format.html do
          @conference.assign_attributes(start_at: conference_params[:start_at], end_at: conference_params[:end_at]) #Set dates back to the user input
          @locations  = @event.locations
          @countries = Country.all
          render action: 'new'
        end
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @conference.assign_attributes(conference_params)
      if @conference.dates_not_set?
        @conference.archived = true
      end
      if @conference.save
        format.html { redirect_to [:organizers, @conference], success: 'Conference was successfully updated.' }
        format.json { head :no_content }
      else
        @conference.assign_attributes(start_at: conference_params[:start_at], end_at: conference_params[:end_at]) #Set dates back to the user input
        set_variables_for_edit_form
        format.html { render 'edit' }
        #format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end


  def edit
    set_variables_for_edit_form
  end

  def show
    @event = @conference.event
  end

  def present
    @event = @conference.event
  end

  def destroy
    @event = @conference.event
    @conference.destroy
    respond_to do |format|
      format.html { redirect_to organizers_event_path(@event) }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conference
      @conference = current_organizer.conferences.find(params[:id])
    end

    def set_event
      @event = current_organizer.events.find(params[:event_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conference_params
      params.require(:conference).permit(:name, :description, :embedded_url, :location_id, :start_at, :end_at, :archived, :tag_list, lecturers_attributes: [:id, :name, :description, :linkedin_url, :country_id, :country_code, :_destroy])
    end

    def set_variables_for_edit_form
      @event = @conference.event
      @locations  = @event.locations
      @conference.lecturers.build if @conference.lecturers.empty?
    end

end
