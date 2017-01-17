class User::ParameterSanitizer < Devise::ParameterSanitizer
  def sign_up
    default_params.permit(:name, :username, :email, :password, :password_confirmation, :tag_list)
  end

  def account_update
    default_params.permit(:username, :email, :password, :password_confirmation, :current_password, :interest_list, :position, :company)
  end
end
