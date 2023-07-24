ActiveAdmin.register Rezzable::WebObject, as: 'Web Object' do
  
  
  menu label: 'Web Objects'

  actions :all, except: %i[new create]
  
  decorate_with Rezzable::WebObjectDecorator
  
  index title: 'Web Objects' do
    selectable_column
    column 'Object Name', sortable: :object_name do |web_object|
      link_to web_object.object_name, admin_web_object_path(web_object)
    end
    column 'Description' do |web_object|
      truncate(web_object.description, length: 10, separator: ' ')
    end    
    column 'Location', sortable: :region, &:slurl
    # column 'Server', sortable: 'server.object_name' do |donation_box|
    #   link_to donation_box.server.object_name,
    #           admin_server_path(donation_box.server) if donation_box.server
    # end
    column 'Owner', sortable: 'users.avatar_name' do |donation_box|
      if donation_box.user
        link_to donation_box.user.avatar_name, admin_user_path(donation_box.user)
      else
        'Orphan'
      end
    end    
    column :status, &:pretty_active

    column :created_at, sortable: :created_at
    actions
  end
  
  
  filter :abstract_web_object_object_name, as: :string, label: 'Object Name'
  filter :abstract_web_object_description, as: :string, label: 'Description'
  filter :abstract_web_object_user_avatar_name, as: :string, label: 'Owner'
  filter :abstract_web_object_region, as: :string, label: 'Region'
  filter :web_object_pinged_at, as: :date_range, label: 'Last Ping'
  filter :abstract_web_object_create_at, as: :date_range
  
  show title: :object_name do
    attributes_table do
      row :object_name
      row :object_key
      row :description
      row 'Owner', sortable: 'users.avatar_name' do |server|
        if server.user
          link_to server.user.avatar_name, admin_user_path(server.user)
        else
          'Orphan'
        end
      end
      row :setting_one
      row :setting_two
      row :location, &:slurl
      row :created_at
      row :updated_at
      row :pinged_at
      row :version, &:semantic_version
      row :status, &:pretty_active
    end
  end

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :object_name, :description, :server_id, 
                :setting_one, :setting_two
  #
  # or
  #
  # permit_params do
  #   permitted = [:object_name, :object_key, :description, :region, :position, :url, :api_key, :user_id, :pinged_at, :major_version, :minor_version, :patch_version, :server_id, :setting_one, :setting_two]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
