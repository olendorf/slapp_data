ActiveAdmin.register Rezzable::Server, as: 'Server' do
  include ActiveAdmin::RezzableBehavior
  
  
  decorate_with Rezzable::ServerDecorator
  
  menu label: 'Servers'

  actions :all, except: %i[new create]
  
  index title: 'Servers' do
    selectable_column
    column 'Object Name', sortable: :object_name do |server|
      link_to server.object_name, admin_server_path(server)
    end
    column 'Description' do |server|
      truncate(server.description, length: 10, separator: ' ')
    end
    # column 'Location', sortable: :region, &:slurl
    column 'Clients' do |server|
      server.clients.count
    end
    column 'Owner', sortable: 'users.avatar_name' do |server|
      if server.user
        link_to server.user.avatar_name, admin_user_path(server.user)
      else
        'Orphan'
      end
    end
    # column 'Version', &:semantic_version
    # column :sttus, &:pretty_active
    # column 'Last Ping', sortable: :pinged_at do |server|
    #   if server.active?
    #     status_tag 'active', label: time_ago_in_words(server.pinged_at)
    #   else
    #     status_tag 'inactive', label: time_ago_in_words(server.pinged_at)
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
  filter :abstract_web_object_create_at, as: :date_range, label: 'Created At'
  
  
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
    
    panel 'Clients' do
      paginated_collection(
        resource.clients.page(
          params[:client_page]
        ).per(20), param_name: 'client_page'
      ) do
        table_for collection.decorate do
          column 'Object Name' do |client|
            path = "admin_#{
              client.model.actable.model_name.route_key
                  .split('_')[1..].join('_').singularize}_path"
            link_to client.object_name, send(path, client.model.actable.id)
          end
          column 'Object Type' do |client|
            client.model.actable.model_name.route_key
                  .split('_')[1..].join('_').singularize.humanize
          end
          column :location, &:slurl
        end
      end
    end
  end
  
  permit_params :object_name, :description

  form title: proc { "Edit #{resource.object_name}" } do |f|
    f.inputs do
      f.input :object_name, label: 'Object name'
      f.input :description
    end
    # f.has_many :splits, heading: 'Splits',
    #                     allow_destroy: true do |s|
    #   s.input :target_name, label: 'Avatar Name'
    #   s.input :target_key, label: 'Avatar Key'
    #   s.input :percent
    # end
    f.actions
  end

end
