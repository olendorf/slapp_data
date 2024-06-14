# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  # before_action :authenticate_user!

  #   after_action :verify_authorized
end
