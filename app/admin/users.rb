# frozen_string_literal: true

ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation

  index do
    selectable_column
    # id_column
    column :avatar_name do |user|
      link_to user.avatar_name, admin_user_path(user)
    end
    column :role do |user|
      user.role.titleize
    end
    column :account_level
    column :web_object_count
    column :web_object_weight
    column :expiration_date
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :avatar_name
  filter :role, as: :check_boxes, collection: User.roles
  filter :expiration_date, as: :date_range
  filter :account_level
  filter :web_object_count
  filter :web_object_weight
  filter :created_at

  show title: :avatar_name do
    attributes_table do
      row :avatar_name
      row :avatar_key
      row 'Role' do |_resource|
        user.role.titleize
      end
      row :account_level
      row :expiration_date
      row :web_object_count
      row :web_object_weight
      row :last_sign_in_at
      row :sign_in_count
      row :created_at
      row :updated_at
    end

    panel 'Terminals' do
      paginated_collection(
        resource.terminals.page(
          params[:terminal_page]
        ).per(20), param_name: 'terminal_page'
      ) do
        table_for collection.decorate do
          column :object_name
        end
      end 
    end if resource.terminals.count > 0
    
    panel 'Servers' do
      paginated_collection(
        resource.servers.page(
          params[:server_page]
        ).per(20), param_name: 'server_page'
      ) do
        table_for collection.decorate do
          column :object_name
        end
      end
    end if resource.servers.count > 0
  end

  sidebar :profile_pic, only: %i[show edit] do
    response = RestClient.get('https://world.secondlife.com/resident/948dbc8e-1072-4beb-90c4-5351904df8c8')
    doc = Nokogiri::HTML(response)
    image_tag doc.css('#content > div.img > img')[0]['src']
  rescue StandardError
    puts 'blank'
    image_tag 'blank_profile/blank-profile-picture-256'
  end

  form do |f|
    f.inputs do
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  controller do
    require 'rest-client'
  end
end
