module Spree
  class HomeController < Spree::BaseController
    def index
      render 'spree/home/index', layout: 'spree/layouts/spree_application'
    end
  end
end
