Spree::Api::UsersController.class_eval do
  def current
    @user = current_api_user
    respond_with(@user)
  end
end
