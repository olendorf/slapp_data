# frozen_string_literal: true

# Base controller class for the application.
class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def authenticate_admin_user!
    if user_signed_in? && !current_user.can_be_admin?
      redirect_to(
        my_dashboard_path
      ) && return
    end

    redirect_to new_user_session_path unless authenticate_user!
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |user_params|
      user_params.permit(:avatar_name, :password, :remember_me)
    end
  end
end
