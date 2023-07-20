# frozen_string_literal: true

require 'api_constraints'

Rails.application.routes.draw do
  devise_for :users
  ActiveAdmin.routes(self)
  get 'static_pages/index'
  root to: 'static_pages#index'

  namespace :api, defaults: { format: 'json' } do
    scope module: :v1, constraints:
              ApiConstraints.new(version: 1, default: true) do
      namespace :rezzable do
        resources :web_objects, except: %i[new edit]
      end
    end
  end
end
