# frozen_string_literal: true

require 'active_support/core_ext/integer/time'

# The test environment is used exclusively to run your application's
# test suite. You never need to work with it otherwise. Remember that
# your test database is "scratch space" for the test suite and is wiped
# and recreated between test runs. Don't rely on the data there!

Rails.application.configure do
  # # rubocop:disable Lint/UselessRescue, Lint/DuplicateBranch, Metrics/MethodLength
  # def set_aws_managed_secrets
  #   # secret name created in aws secret manager
  #   secret_name = if ENV['RAISL_ENV']
  #                   "#{ENV.fetch('RAILS_ENV', nil)}/database-1/postgres/postgres"
  #                 else
  #                   'development/database-1/postgres/postgres'
  #                 end
  #   # region name
  #   region_name = 'us-east-2'

  #   client = Aws::SecretsManager::Client.new(region: region_name)

  #   begin
  #     secret_value = client.get_secret_value(secret_id: secret_name)
  #   rescue Aws::SecretsManager::Errors::DecryptionFailure => e
  #     raise e
  #   rescue Aws::SecretsManager::Errors::InternalServiceError => e
  #     raise e
  #   rescue Aws::SecretsManager::Errors::InvalidParameterException => e
  #     raise e
  #   rescue Aws::SecretsManager::Errors::InvalidRequestException => e
  #     raise e
  #   rescue Aws::SecretsManager::Errors::ResourceNotFoundException => e
  #     raise e
  #   else
  #     if secret_value.secret_string
  #       secret_hash = JSON.parse(secret_value.secret_string)
  #       ENV['DB_IP'] = secret_hash['host']
  #       ENV['DB_USERNAME'] = secret_hash['username']
  #       ENV['DB_PASSWORD'] = secret_hash['password']
  #     end
  #   end
  # end

  # # rubocop:enable Lint/UselessRescue, Lint/DuplicateBranch, Metrics/MethodLength

  set_aws_managed_secrets
  # Settings specified here will take precedence over those in config/application.rb.

  # While tests run files are not watched, reloading is not necessary.
  config.enable_reloading = false

  # Eager loading loads your entire application. When running a single test locally,
  # this is usually not necessary, and can slow down your test suite. However, it's
  # recommended that you enable it in continuous integration systems to ensure eager
  # loading is working properly before deploying your code.
  config.eager_load = ENV['CI'].present?

  # Configure public file server for tests with Cache-Control for performance.
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.to_i}"
  }

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false
  config.cache_store = :null_store

  config.cache_classes = false

  # Render exception templates for rescuable exceptions and raise for other exceptions.
  config.action_dispatch.show_exceptions = :rescuable

  # Disable request forgery protection in test environment.
  config.action_controller.allow_forgery_protection = false

  # Store uploaded files on the local file system in a temporary directory.
  config.active_storage.service = :test

  config.action_mailer.perform_caching = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Print deprecation notices to the stderr.
  config.active_support.deprecation = :stderr

  # Raise exceptions for disallowed deprecations.
  config.active_support.disallowed_deprecation = :raise

  # Tell Active Support which deprecation messages to disallow.
  config.active_support.disallowed_deprecation_warnings = []

  # Raises error for missing translations.
  # config.i18n.raise_on_missing_translations = true

  # Annotate rendered view with file names.
  # config.action_view.annotate_rendered_view_with_filenames = true

  # Raise error when a before_action's only/except options reference missing actions
  config.action_controller.raise_on_missing_callback_actions = true
end
