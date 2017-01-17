class EventCodeRequestsController < ApplicationController

  before_filter :authenticate_organizer!

  def new
    EventCodeRequestMailer.new_request(current_organizer).deliver
    store_location
    redirect_to action: :show
  end

  def show
    @return_to = return_to
    clear_stored_location
  end

  private

  def store_location
    session[:return_to] = request.referrer
  end

  def clear_stored_location
    session.delete(:return_to)
  end

  def return_to
    session[:return_to]
  end
end
