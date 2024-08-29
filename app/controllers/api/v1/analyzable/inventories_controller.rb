class Api::V1::Analyzable::InventoriesController < Api::V1::AnalyzableController
  
  def index           
    authorize [:api, :v1, @requesting_object.actable]

    params['inventory_page'] ||= 1
    page = @requesting_object.actable.inventories
                             .page(params['inventory_page']).per(9)
    data = paged_data(page)
    render json: { data: data }, status: :ok
  end
  
  def show
    authorize [:api, :v1, @requesting_object.actable]
    @inventory = ::Analyzable::Inventory.find_by_inventory_name!(
      params['inventory_name']
    )
    data = @inventory.attributes.except(:id, :user_id,
                                        :server_id, :created_at, :updated_at)
    render json: { message: 'OK', data: data }, status: :ok
  end
  
  def create
    authorize [:api, :v1, @requesting_object.actable]

    begin
      @inventory = @requesting_object.actable.inventories
                                     .find_by_inventory_name!(atts['inventory_name'])
      update
    rescue ActiveRecord::RecordNotFound
      @requesting_object.actable.inventories << ::Analyzable::Inventory.new(atts)
      render json: { message: 'Created' }, status: :created
    end
  end
  
  def update
    authorize [:api, :v1, @requesting_object.actable]
    load_inventory unless @inventory
    @inventory.update(atts)
    render json: { message: 'Updated' }, status: :ok
  end        
  
  def destroy
    authorize [:api, :v1, @requesting_object.actable]
    if params['inventory_name'] == 'all'
      msg = 'all inventories cleared.'
      @requesting_object.actable.inventories.destroy_all
    else
      @inventory = ::Analyzable::Inventory.find_by_inventory_name!(
        params['inventory_name']
      )
      @inventory.destroy!
      msg = "#{@inventory.inventory_name} deleted"
    end
    render json: { message: msg }, status: :ok
  end
  

  
  private

  def paged_data(page)
    {
      inventory: page.map(&:inventory_name),
      current_page: page.current_page,
      next_page: page.next_page,
      prev_page: page.prev_page,
      total_pages: page.total_pages
    }
  end
end
