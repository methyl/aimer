Aimer::Application.routes.draw do
  mount Spree::Core::Engine, :at => '/spree'

  Spree::Core::Engine.routes.append do
    namespace :api, defalts: { format: 'json' } do
      get 'current_user' => 'users#current'
    end
  end

  root to: 'spree/home#index'
  get :checkout, controller: 'spree/home', action: 'index'
  get :about, controller: 'spree/home', action: 'index'
  get :contact, controller: 'spree/home', action: 'index'
  get 'why_dum_dum', controller: 'spree/home', action: 'index'
  get 'tos', controller: 'spree/home', action: 'index'
  get 'cooperation', controller: 'spree/home', action: 'index'
end

