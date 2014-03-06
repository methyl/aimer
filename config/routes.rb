Aimer::Application.routes.draw do
  mount Spree::Core::Engine, :at => '/'

  # Spree::Core::Engine.add_routes do
  #   namespace :api do
  #     get 'users/current', controller: 'users', action: 'current'
  #     # resources :users do
  #     #   collection do
  #     #     get :current
  #     #   end
  #   end
  # end
  Spree::Core::Engine.routes.append do
    namespace :api, defalts: { format: 'json' } do
      get 'current_user' => 'users#current'
    end
  end
end

