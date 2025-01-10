# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  get 'static_pages/home'
  get 'static_pages/products'
  get 'static_pges/product_servers'
  get 'static_pages/product_traffic_cops'
  get 'static_pages/docs'
  get 'static_pages/docs_getting_started'
  get 'static_pages/docs_servers'
  get 'static_pages/docs_traffic_cops'
  get 'static_pages/help'
  require 'api_constraints'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  root to: 'static_pages#home'

  # Defines the root path route ("/")
  # root "posts#index"
  
  namespace :async, defaults: { format: 'json' } do
    resources :visits, only: %i[index]
  end

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1,
          constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, except: %i[index new edit], param: :avatar_key
      resources :listable_avatars, only: %i[index]

      namespace :analyzable do
        resources :inventories, except: %i[new edit], param: :inventory_name
        resources :transactions, only: %i[create]
      end

      namespace :rezzable do
        resources :web_objects, except: %i[index new edit], param: :object_key
        resources :terminals, except: %i[index new edit], param: :object_key do
          member do
            put 'give'
          end
        end
        resources :servers, except: %i[new edit], param: :object_key
        resources :traffic_cops, except: %i[new edit], param: :object_key
        resources :donation_boxes, except: %i[new edit], param: :object_key
      end
    end
  end
end
