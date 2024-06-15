# frozen_string_literal: true

ActiveAdmin.register Rezzable::WebObject, as: 'Web Object' do
  include ActiveAdmin::RezzableBehavior
  decorate_with Rezzable::WebObjectDecorator

  actions :all, except: %i[new create]

  index title: 'Web Objects' do
    selectable_column
    column 'Object Name', sortable: :object_name do |web_object|
      link_to web_object.object_name, admin_web_object_path(web_object)
    end
    column 'Owner', sortable: :owner_name do |web_object|
      link_to web_object.user.avatar_name, admin_user_path(web_object.user)
    end
    column 'Description' do |web_object|
      truncate(web_object.description, length: 10, separator: ' ')
    end
    column 'Location', sortable: :region, &:slurl
    column :created_at, sortable: :created_at
    column :updated_at, sortable: :updated_at
    actions
  end

  filter :abstract_web_object_object_name, as: :string, label: 'Object Name'
  filter :abstract_web_object_description, as: :string, label: 'Description'
  filter :abstract_web_object_user_avatar_name, as: :string, label: 'Owner'
  filter :abstract_web_object_region, as: :string, label: 'Region'
  filter :abstract_web_object_created_at, as: :date_range, label: 'Created At'

  show title: :object_name do
    attributes_table do
      row :object_name
      row :object_key
      row :description
      row 'Owner' do |web_object|
        if web_object.user
          link_to web_object.user.avatar_name, admin_user_path(web_object.user)
        else
          'Orphan'
        end
      end
      row :location, &:slurl
      row :created_at
      row :updated_at
    end
  end

  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :object_name, :object_key, :owner_name, :owner_key, :region,
  # :position, :shard, :url, :user_id, :api_key
  #
  # or
  #
  # permit_params do
  #   permitted = [:object_name, :object_key, :owner_name, :owner_key, :region,
  # .          :position, :shard, :url, :user_id, :api_key]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end