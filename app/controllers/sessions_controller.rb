#
#
#  How To: Redirect here to a specific page when the user can not be authenticated
#  https://github.com/plataformatec/devise/wiki/How-To:-Redirect-to-a-specific-page-when-the-user-can-not-be-authenticated
#
#
# class SessionsController < Devise::SessionsController
#   def new
#   	logger.debug " entro al SessionsController"
#   end
#
#   def create
#   	email = params[:email]
#     password = params[:password]
# 	logger.debug "email #{email}"
# 	logger.debug "password #{password}"
#
#     if (email.nil? || email.empty?) or (password.nil? || password.empty?)
#        #render :status=>400,
#        #       :json=>{:message=>"The request must contain the user email and password."}
#        #return
#        return redirect_to signin_path , :flash => { :error => "Debes ingresar los campos"}
#     end
#
#     @user = User.find_by(email: params[:email])
#     logger.debug "user #{@user}"
#   	if  @user.nil?
#   		@organizer = Organizer.find_by(email: params[:email])
#       unless @organizer.nil?
#         if @organizer.valid_password?(password)
#           sign_in(:organizer, @organizer)
#           return redirect_to organizers_events_path
#         else
#           return redirect_to signin_path , :flash => { :error => "Invalid user/password combination"}
#         end
#       end
#
#   	else
#   		if @user.valid_password?(password)
#   			sign_in(:user, @user)
#   			return redirect_to dashboard_path
#   		else
#   			return redirect_to signin_path , :flash => { :error => "Invalid user/password combination"}
#   		end
#   	end
#   	return redirect_to signin_path , :flash => { :error => "Incorrect user"}
#   end
# end
