# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.2.2'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~>7.1'

# gem "sassc-rails"

# The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem 'sprockets-rails'

# Use sqlite3 as the database for Active Record
# gem "sqlite3", "~> 1.4"
gem 'pg'

# Use the Puma web server [https://github.com/puma/puma]
gem 'puma'

# Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem 'importmap-rails'

# Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem 'turbo-rails'

# Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem 'stimulus-rails'

# Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem 'jbuilder'

# User authentication
gem 'devise'

# Authorization
gem 'pundit'

# Decorator
gem 'draper'

# Easy db management for admin and users
gem 'activeadmin'

# Configuration for application
gem 'config'

# A simple HTTP and REST client for Ruby, inspired by the Sinatra's 
# microframework style of specifying actions: get, put, post, delete.
gem 'rest-client'

gem 'aws-sdk-secretsmanager'

# Use Redis adapter to run Action Cable in production
# gem "redis", "~> 4.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password
# [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', require: false

# Use Sass to process CSS
gem 'sassc-rails'

gem 'bootstrap'

# Multi-table Inheritance
gem 'active_record-acts_as'

# Use Active Storage variants [https://guides.rubyonrails.org/active_storage_overview.html#transforming-images]
# gem "image_processing", "~> 1.2"

# gem 'coveralls', require: false
gem 'coveralls_reborn', require: false

group :test do
  gem 'capybara' # For integration testing.
  gem 'selenium-webdriver' # Web page interaction
  gem 'webmock' # Allows mocking of web apis for instance
end

group :test, :development do
  gem 'database_cleaner'                  # Allows isolated testing of DB interactions.
  gem 'guard-rspec'                       # Integrate Guard with Rspec
  gem 'guard-spring'                      # Integrate Guard with Spring
  gem 'rspec-rails'                       # Rspec
  gem 'shoulda-matchers' # Really handy RSpec matchers not included with RSpec
  gem 'spring-commands-rspec', group: :development
end

# Installed outside of environments to allow access in production. If you don't want this just put it
# in group :development, :test
gem 'factory_bot_rails' # Creates factories for models
gem 'faker' # Handy for creating fake data

group :development do
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console'

  # Spring speeds up development by keeping your application running in the background. Read     more:         https://github.com/rails/spring
  gem 'spring'
end


#content > div.img > img