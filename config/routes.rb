Rails.application.routes.draw do
  
  require 'api_constraints'
  
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  
  root to: "home#index"

  # Defines the root path route ("/")
  # root "posts#index"
  
  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, 
      constraints: ApiConstraints.new(version: 1, default: true) do
        resources :users, except: %i[index new edit], param: :avatar_key
      end
  end
end
