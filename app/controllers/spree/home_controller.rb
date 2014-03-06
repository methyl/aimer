module Spree
  class HomeController < Spree::BaseController
    def index
      @session = session.to_json
      render 'spree/home/index', layout: 'spree/layouts/spree_application'
    end
  end
end
