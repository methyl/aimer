Aimer::Application.routes.draw do
  mount Spree::Core::Engine, :at => '/spree'

  Spree::Core::Engine.routes.append do
    namespace :api, defalts: { format: 'json' } do
      get 'current_user' => 'users#current'
    end
  end

  root to: 'spree/home#index'
  get :checkout, controller: 'spree/home', action: 'index'
  get :complete, controller: 'spree/home', action: 'index'
end

