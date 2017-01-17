class Organizers::EventsController < ApplicationController
  include Organizers::EventsConcerns
  respond_to :html
  respond_to :json

  before_filter :authenticate_organizer!
  before_action :set_event, only: [:show, :edit, :update, :destroy, :publish]

  ##helper_method :dummy

  def index
    @current_events = current_organizer.events.where("start_at <= ? AND end_at >= ? AND status != ?", Time.zone.now, Time.zone.now, 'draft' ).page(params[:page]).per(20)
    @events = case params[:filter]
    when "previous"
      current_organizer.events.where("end_at < ? AND status != ?", Time.zone.now, 'draft').page(params[:page]).per(20)
    when "upcoming"
      current_organizer.events.where("start_at > ? AND status != ?", Time.zone.now, 'draft').page(params[:page]).per(20)
    else
      current_organizer.events.where("status = ?", 'draft').page(params[:page]).per(20)
    end

  end

  def new
    @event = current_organizer.events.new
    @event.locations.build
    # @event.indications.build
  end

  def show

    flash.now[:info] = "This event is happening right now." if (@event.in_time? && @event.published? )
    @current_conferences = @event.get_current_conferences
    now = Time.zone.now.utc
    @conferences = case params[:filter]
    when "previous"
      @event.conferences.where("start_at < ? AND end_at < ?  AND archived = ?", now, now, false).page(params[:page]).per(20).order("start_at ASC")
    when "upcoming"
      @event.conferences.where("start_at >= ? AND archived = ?", now, false).page(params[:page]).per(20).order("start_at ASC")
    else #when drafts
      @event.conferences.where("archived = ?", true).page(params[:page]).per(20).order("start_at ASC")
    end
  end

  def edit
    @event.indications.build unless @event.indications.present?
    @event.locations.build unless @event.locations.present?
  end

  def create
      @event = create_event(current_organizer, event_params)
      flash[:notice] = t("flash.actions.organizers.events.create.success") unless @event.id.blank?
      respond_with @event, location: new_organizers_conference_path(event_id: @event.id)
  end

  def update
    result, signal = update_event(@event, event_params)
    flash[result] = t("flash.actions.organizers.events.update.#{signal}") 
    respond_with @event, location: [:organizers, @event]
  end

  def publish
    begin
      if params[:publish].present?
        result, signal = publish_or_unpublish(@event, params[:publish], params[:token])
        flash[result] = t("flash.actions.organizers.events.publish.#{signal}") 
        respond_with @event, location: [:organizers, @event]
      end
    rescue 
      flash[:error] = t("flash.actions.organizers.events.publish.exception") 
      respond_with @event, location: [:organizers, @event]
    end
  end

  def destroy
    @event.destroy
    respond_to do |format|
      format.html { redirect_to organizers_events_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      begin
        @event = current_organizer.events.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        flash[:error] = "The event you tried to reach is NOT of yours! This incident will be reported." #TODO
        redirect_to action: :index
      end
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def event_params
      params.require(:event).permit(:name, :set_location_to_all_confs, :timezone, :logo, :map_picture, :description,
        :start_at, :end_at, :tag_list, locations_attributes: [:id, :name, :address,
        :latitude, :longitude, :_destroy], indications_attributes: [:id, :content,
          :kind, :_destroy] ) if params[:event].present?
    end
end
