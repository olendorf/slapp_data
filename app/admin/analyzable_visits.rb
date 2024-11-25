# frozen_string_literal: true

ActiveAdmin.register Analyzable::Visit, as: 'Visit' do
  menu label: 'Visits'

  decorate_with Analyzable::VisitDecorator

  actions :all, except: %(new create delete destroy)

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :avatar_name, :avatar_key, :region, :duration, :traffic_cop_id, :user_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:avatar_name, :avatar_key, :region, :duration, :traffic_cop_id, :user_id]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end
