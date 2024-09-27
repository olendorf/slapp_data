# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

Rails.application.configure do
  # rubocop:disable Lint/UselessRescue, Lint/DuplicateBranch, Metrics/MethodLength
  def set_aws_managed_secrets
    # secret name created in aws secret manager
    secret_name = if ENV['RAISL_ENV']
                    "#{ENV.fetch('RAILS_ENV', nil)}/database-1/postgres/postgres"
                  else
                    'development/database-1/postgres/postgres'
                  end
    # region name
    region_name = 'us-east-2'

    client = Aws::SecretsManager::Client.new(region: region_name)
    # config.logger = Logger.new(STDOUT)
    # config.log_level = :debug

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

  # rubocop:enable Lint/UselessRescue, Lint/DuplicateBranch, Metrics/MethodLength

  set_aws_managed_secrets
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded any time
  # it changes. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.enable_reloading = true

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable server timing
  config.server_timing = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  config.action_mailer.perform_caching = false

  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Highlight code that enqueued background job in logs.
  config.active_job.verbose_enqueue_logs = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Uncomment if you wish to allow Action Cable access from any origin.
  # config.action_cable.disable_request_forgery_protection = true

  # Raise error when a before_action's only/except options reference missing actions
  config.action_controller.raise_on_missing_callback_actions = true

  config.hosts << 'ec0896c0be6f417f9e0f45613a3c31b1.vfs.cloud9.us-east-2.amazonaws.com'
  config.hosts << 'sl-dev.slappdata.com'
end
