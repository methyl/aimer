require 'new_relic/agent/instrumentation/action_controller_subscriber'
require 'new_relic/agent/instrumentation/rails4/action_controller'

Spree::Api::BaseController.class_eval do
  before_filter :check_for_user

  def check_for_user
    if try_spree_current_user
      @current_api_user = spree_current_user
    end
  end

  include NewRelic::Agent::Instrumentation::ControllerInstrumentation
  include NewRelic::Agent::Instrumentation::Rails4::ActionController

  NewRelic::Agent::Instrumentation::ActionControllerSubscriber \
    .subscribe(/^process_action.action_controller$/)

end
