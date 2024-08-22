# frozen_string_literal: true

ActiveAdmin.register Rezzable::Terminal, as: 'Terminal' do
  include ActiveAdmin::RezzableBehavior

  menu label: 'Terminals'

  actions :all, except: %i[new create]
  
  index title: 'Terminals' do
    selectable_column
    column 'Object Name', sortable: :object_name do |terminal|
      link_to terminal.object_name, admin_terminal_path(terminal)
    end
    column 'Description' do |terminal|
      truncate(terminal.description, length: 10, separator: ' ')
    end
    # column 'Location', sortable: :region, &:slurl
    # column 'Server', sortable: 'server.object_name' do |terminal|
    #   link_to terminal.server.object_name, admin_server_path(terminal.server) if terminal.server
    # end
    column 'Owner', sortable: 'users.avatar_name' do |terminal|
      if terminal.user
        link_to terminal.user.avatar_name, admin_user_path(terminal.user)
      else
        'Orphan'
      end
    end
    # column 'Version', &:semantic_version
    # column :sttus, &:pretty_active
    # column 'Last Ping', sortable: :pinged_at do |terminal|
    #   if terminal.active?
    #     status_tag 'active', label: time_ago_in_words(terminal.pinged_at)
    #   else
    #     status_tag 'inactive', label: time_ago_in_words(terminal.pinged_at)
    #   end
    # end
    column :created_at, sortable: :created_at
    actions
  end
  
  filter :abstract_web_object_object_name, as: :string, label: 'Object Name'
  filter :abstract_web_object_description, as: :string, label: 'Description'
  filter :abstract_web_object_user_avatar_name, as: :string, label: 'Owner'
  filter :abstract_web_object_region, as: :string, label: 'Region'
  # filter :web_object_pinged_at, as: :date_range, label: 'Last Ping'
  filter :abstract_web_object_create_at, as: :date_range

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :object_name, :object_key, :region, :position, :shard, :url, :user_id, :api_key, :description
  #
  # or
  #
  # permit_params do
  #   permitted = [:object_name, :object_key, :region, :position, :shard, :url, :user_id, :api_key, :description]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
