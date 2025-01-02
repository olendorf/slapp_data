# frozen_string_literal: true

ActiveAdmin.register Rezzable::TrafficCop, as: 'Traffic Cop' do
  include ActiveAdmin::RezzableBehavior
  decorate_with Rezzable::TrafficCopDecorator

  menu label: 'Traffic Cops'

  actions :all, except: %i[new create]

  index title: 'Traffic_Cops' do
    selectable_column
    column 'Object Name', sortable: :object_name do |traffic_cop|
      link_to traffic_cop.object_name, admin_traffic_cop_path(traffic_cop)
    end
    column 'Description' do |traffic_cop|
      truncate(traffic_cop.description, length: 10, separator: ' ')
    end
    column 'Location', sortable: :region, &:slurl
    column 'Owner', sortable: 'users.avatar_name' do |traffic_cop|
      if traffic_cop.user
        link_to traffic_cop.user.avatar_name, admin_user_path(traffic_cop.user)
      else
        'Orphan'
      end
    end
    column 'Server' do |traffic_cop|
      if traffic_cop.server
        link_to traffic_cop.object_name, admin_server_path(traffic_cop.server)
      else
        'No Server'
      end
    end
    # column 'Version', &:semantic_version
    # column :sttus, &:pretty_active
    # column 'Last Ping', sortable: :pinged_at do |traffic_cop|
    #   if traffic_cop.active?
    #     status_tag 'active', label: time_ago_in_words(traffic_cop.pinged_at)
    #   else
    #     status_tag 'inactive', label: time_ago_in_words(traffic_cop.pinged_at)
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
      row 'Server' do |web_object|
        if web_object.server
          link_to web_object.object_name, admin_server_path(web_object.server)
        else
          'No Server'
        end
      end
      row 'Inventory to give' do |web_object|
        if web_object.inventory
          link_to web_object.inventory.inventory_name, admin_inventory_path(web_object.inventory)
        else
          'No inventory set'
        end
      end
      row :location, &:slurl
      row :created_at
      row :updated_at
    end

    panel 'Visits' do
      paginated_collection(
        resource.visits.order(created_at: :desc).page(
          params[:visit_page]
        ).per(20), param_name: 'visit_page', download_links: false
      ) do
        table_for collection do
          column :avatar_name
          column :avatar_key
          column 'Start Time', &:created_at
          column 'Duration' do |visit|
            ChronicDuration.output(visit.duration)
          end
        end
      end
    end

    panel 'Visitors' do
      data = resource.visitors
      paginated_data = Kaminari.paginate_array(data).page(params['visitor_page']).per(20)
      div class: 'paginated_collection' do
        table_for paginated_data do
          column :avatar_name
          column :avatar_key
          column :visits
          column 'Time spent' do |visitor|
            ChronicDuration.output(visitor[:time_spent])
          end
        end
        div id: 'visitors-footer' do
          paginate paginated_data, param_name: 'visitor_page'
        end
        div class: 'pagination_information' do
          page_entries_info paginated_data, entry_name: 'Visitors'
        end
      end
    end
    
    panel '' do
      div class: 'column md' do
        render partial: 'visits_histogram'
      end
      # div class: 'column md' do
      #   render partial: 'visitors_time_histogram'
      # end
    end
  end

  sidebar :settings, only: %i[edit show] do
    attributes_table do
      # row :power
      row 'Power' do |traffic_cop|
        traffic_cop.decorate.pretty_power
      end
      row 'Sensor mode' do |traffic_cop|
        traffic_cop.decorate.pretty_sensor_mode
      end
      row 'Security mode' do |traffic_cop|
        traffic_cop.decorate.pretty_security_mode
      end
      row 'Access mode' do |traffic_cop|
        traffic_cop.decorate.pretty_access_mode
      end
      row :first_visit_message
      row :repeat_visit_message
      row :inventory_to_give
    end
  end

  #   panel 'Visitors' do
  #     data = resource.visitors
  #     paginated_data = Kaminari.paginate_array(data).page(params['visitor_page']).per(20)
  #     div class: 'paginated_collection' do
  #       table_for paginated_data do
  #         column :avatar_name
  #         column :avatar_key
  #         column :visits
  #         column :time_spent
  #       end
  #       div id: 'visitors-footer' do
  #         paginate paginated_data, param_name: 'visitor_page'
  #       end
  #       div class: 'pagination_information' do
  #         page_entries_info paginated_data, entry_name: 'Visitors'
  #       end
  #     end
  #   end
  # end
  # objects_array.sort_by{ |obj| obj.attribute }.reverse
  sidebar :current_visitors, only: %i[edit show] do
    # data = resource.visits.where('updated_at > ?', 2.minutes.ago)
    paginated_data = Kaminari.paginate_array(resource.current_visitors)
                             .page(params['current_page']).per(10)

    div class: 'paginated_data' do
      table_for paginated_data do
        column :avatar_name
        column :start_time
        column 'Duration' do |visit|
          ChronicDuration.output(visit.duration)
        end
      end
    end
  end
  
  

  sidebar :allowed, only: %i[edit show] do
    paginated_collection(
      resource.allowed.order(:avatar_name).page(
        params[:allowed_page]
      ).per(10), param_name: 'allowed_page', download_links: false
    ) do
      table_for collection do
        column :avatar_name
        column '' do |avatar|
          link_to 'Delete',  admin_listable_avatar_path(avatar),
                  method: :delete,
                  data: { confirm: 'Delete this allowed avatar?' }
        end
      end
    end

    render partial: 'add_listable_form', locals: { list_name: 'allowed' }
  end

  sidebar :banned, only: %i[edit show] do
    paginated_collection(
      resource.banned.order(:avatar_name).page(
        params[:banned_page]
      ).per(10), param_name: 'banned_page', download_links: false
    ) do
      table_for collection do
        column :avatar_name
        column '' do |avatar|
          link_to 'Delete',  admin_listable_avatar_path(avatar),
                  method: :delete,
                  data: { confirm: 'Unban this avatar?' }
        end
      end
    end

    render partial: 'add_listable_form', locals: { list_name: 'banned' }
  end

  permit_params :object_name, :description, :server_id, :power, :sensor_mode, :security_mode,
                :access_mode, :first_visit_message, :repeat_visit_message, :inventory_id

  form title: proc { "Edit #{resource.object_name}" } do |f|
    f.inputs do
      f.input :object_name, label: 'Donation Box name'
      f.input :description
      if resource.user.servers.count.positive?
        f.input :server_id, label: 'Server',
                            as: :select, collection: resource.user.servers.map { |server|
                                                       [server.object_name, server.id]
                                                     }
      end
      f.input :power, as: :select, collection: Rezzable::TrafficCop.powers.collect { |k, _v|
                                                 [k.split('_').last.titleize, k]
                                               },
                      selected: resource.power,
                      include_blank: false
      f.input :sensor_mode, as: :select,
                            collection: Rezzable::TrafficCop.sensor_modes.collect { |k, _v|
                              [k.split('_')[2..].join(' ').titleize, k]
                            },
                            selected: resource.sensor_mode,
                            include_blank: false
      f.input :security_mode, as: :select,
                              collection: Rezzable::TrafficCop.security_modes.collect { |k, _v|
                                [k.split('_')[2..].join(' ').titleize, k]
                              },
                              selected: resource.security_mode,
                              include_blank: false
      f.input :access_mode, as: :select,
                            collection: Rezzable::TrafficCop.access_modes.collect { |k, _v|
                              [k.split('_')[2..].join(' ').titleize, k]
                            },
                            selected: resource.access_mode,
                            include_blank: false
      f.input :first_visit_message
      f.input :repeat_visit_message
      if resource.server
        f.input :inventory_id, label: 'Inventory To Give',
                               as: :select,
                               collection: resource.server.inventories
                                                   .map { |i| [i.inventory_name, i.id] }

      end
    end
    f.actions
  end
  
  controller do
    def show
      # gon.ids = [resource.id]
      params['resource_ids'] = [resource.id]
      super
    end
  end
end
