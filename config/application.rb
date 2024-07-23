# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SlappData
  # The main config for the application
  class Application < Rails::Application
    def set_aws_managed_secrets
      # secret name created in aws secret manager
      if ENV['RAISL_ENV']
        secret_name = "#{ENV['RAILS_ENV']}/database-1/postgres/postgres"
      else
        secret_name = 'development/database-1/postgres/postgres'
      end
      # region name
      region_name = 'us-east-2'
    
      client = Aws::SecretsManager::Client.new(region: region_name)
    
      begin
        secret_value = client.get_secret_value(secret_id: secret_name)
      rescue Aws::SecretsManager::Errors::DecryptionFailure => e
        raise e
      rescue Aws::SecretsManager::Errors::InternalServiceError => e
        raise e
      rescue Aws::SecretsManager::Errors::InvalidParameterException => e
        raise e
      rescue Aws::SecretsManager::Errors::InvalidRequestException => e
        raise e
      rescue Aws::SecretsManager::Errors::ResourceNotFoundException => e
        raise e
      else
        if secret_value.secret_string
          secret_hash = JSON.parse(secret_value.secret_string)
          ENV['DB_IP'] = secret_hash['host']
          ENV['DB_USERNAME'] = secret_hash['username']
          ENV['DB_PASSWORD'] = secret_hash['password']
        end
      end
    end
    
    
    
    set_aws_managed_secrets
    
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    # Please, add to the `ignore` list any other `lib` subdirectories that do
    # not contain `.rb` files, or that should not be reloaded or eager loaded.
    # Common ones are `templates`, `generators`, or `middleware`, for example.
    config.autoload_lib(ignore: %w[assets tasks])

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
