require 'new_relic/agent/instrumentation/action_controller_subscriber'
require 'new_relic/agent/instrumentation/rails4/action_controller'

Spree::Api::BaseController.class_eval do
  before_filter :check_for_user

  def check_for_user
    if try_spree_current_user
      @current_api_user = spree_current_user
    end
  end

end
