# frozen_string_literal: true

Rails.application.routes.draw do
  get 'static_pages/home'
  get 'static_pages/admin'
  get 'static_pages/user'
  
  ActiveAdmin.routes(self)
  devise_for :users, ActiveAdmin::Devise.config
  
  get 'static_pages/home'
  get 'static_pages/about'
  require 'api_constraints'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  root to: 'static_pages#home'

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, except: %i[index new edit], param: :avatar_key

      namespace :rezzable do
        resources :web_objects, except: %i[index new edit], param: :object_key
      end
    end
  end
end
