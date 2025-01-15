# frozen_string_literal: true

ActiveAdmin.register Rezzable::DonationBox, as: 'Donation Box' do
  include ActiveAdmin::RezzableBehavior
  decorate_with Rezzable::DonationBoxDecorator

  actions :all, except: %i[new create]

  index title: 'Donation Boxes' do
    selectable_column
    column 'Object Name', sortable: :object_name do |donation_box|
      link_to donation_box.object_name, admin_donation_box_path(donation_box)
    end
    column 'Owner', sortable: :owner_name do |donation_box|
      link_to donation_box.user.avatar_name, admin_user_path(donation_box.user)
    end
    column 'Description' do |donation_box|
      truncate(donation_box.description, length: 10, separator: ' ')
    end
    column 'Server', sortable: 'server.object_name' do |donation_box|
      if donation_box.server
        link_to donation_box.server.object_name,
                admin_server_path(donation_box.server)
      end
    end
    column 'Amount Donated' do |donation_box|
      donation_box.transactions.sum(:amount)
    end
    column 'Donations' do |donation_box|
      donation_box.transactions.count
    end
    column 'Location', sortable: :region, &:slurl
    column :created_at, sortable: :created_at
    column :updated_at, sortable: :updated_at
    column 'Status' do |donation_box|
      donation_box.pretty_status
    end
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
      row 'Owner' do |donation_box|
        if donation_box.user
          link_to donation_box.user.avatar_name, admin_user_path(donation_box.user)
        else
          'Orphan'
        end
      end
      row 'Server' do |donation_box|
        if donation_box.server
          link_to donation_box.server.object_name, admin_server_path(donation_box.server)
        else
          'No Server'
        end
      end
      row :location, &:slurl
      row 'Total Donations' do |donation_box|
        "L$ #{donation_box.transactions.sum(:amount)}"
      end
      row 'Largest Donation' do |donation_box|
        "L$ #{donation_box.transactions.order(:amount).last.amount}"
      end
      row 'Biggest Donor' do |donation_box|
        donor = donation_box.biggest_donor
        "#{donor[:target_name]} ( L$ #{donor[:amount]} )"
      end 
      row :created_at
      row :updated_at
      row 'Status' do |donation_box|
        donation_box.pretty_status
      end
    end
    
    panel 'Donations' do
      paginated_collection(
        resource.transactions.order(created_at: :desc).page(
        params[:donation_page]
        ).per(20), param_name: 'donation_page', download_links: false
      ) do 
        table_for collection do
          column :target_name
          column :target_key
          column :amount
          column 'Date' do |donation|
            donation.created_at
          end
        end
      end
    end
    
    panel 'Donors' do 
      data = resource.donors
      paginated_data = Kaminari.paginate_array(data).page(params['donor_page']).per(20)
      div class: 'paginated_collection' do
        table_for paginated_data do 
          column :target_name
          column :target_key
          column :amount
          column 'Donations' do |donor|
            donor[:count]
          end
        end
        div id: 'donors-footer' do
          paginate paginated_data, param_name: 'donor_Page'
        end
        div class: 'pagination_information' do 
          page_entries_info paginated_data, entry_name: 'Donors'
        end
      end
    end
    
      
    panel '' do 
      div class: 'column centered' do 
        render partial: 'donations_timeline'
      end 
    end
    
    panel '' do 
      div class: 'column md' do 
        render partial: 'donations_histogram'
      end
      
      div class: 'column md' do 
        render partial: 'donors_histogram'
      end
    end
    
    panel '' do 
      div class: 'column md centered' do 
        render partial: 'donor_amount_count_scatter'
      end
    end
  end


  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :object_name, :description, :server_id

  form title: proc { "Edit #{resource.object_name}" } do |f|
    f.inputs do
      f.input :object_name, label: 'Object name'
      f.input :description
      f.input :server_id, label: 'Server',
                          as: :select, collection: resource.user.servers.map { |server|
                                                     [server.object_name, server.id]
                                                   }
    end
    # f.has_many :splits, heading: 'Splits',
    #                     allow_destroy: true do |s|
    #   s.input :target_name, label: 'Avatar Name'
    #   s.input :target_key, label: 'Avatar Key'
    #   s.input :percent
    # end
    f.actions
  end
  #
  # or
  #
  # permit_params do
  #   permitted = [:object_name, :object_key, :owner_name, :owner_key, :region,
  # .          :position, :shard, :url, :user_id, :api_key]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
  controller do
    def show
      d = Rezzable::DonationBox.find resource.id
      params['resource_ids'] = [d.abstract_web_object.id]
      super
    end
  end
end
