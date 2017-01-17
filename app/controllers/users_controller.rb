class UsersController < ApplicationController
  before_filter :authenticate_user!, only: [:index]
  before_action :set_user, only: [:index]

  # Dashboard
  def index
      logger.debug "user #{@user.name}"
      @user_events = @user.events
  end

  # Profile
  def show
    @user = User.find params[:id]
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end
end
