Spree::Api::UsersController.class_eval do
  include Devise::Controllers::Helpers

  def create
    authorize! :create, Spree.user_class
    @user = Spree.user_class.new(user_params)
    if @user.save
      sign_in @user
      respond_with(@user, :status => 201, :default_template => :show)
    else
      invalid_resource!(@user)
    end
  end

  def current
    @user = current_api_user
    respond_with(@user)
  end
end
