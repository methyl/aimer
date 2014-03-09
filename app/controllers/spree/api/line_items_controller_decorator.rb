Spree::Api::LineItemsController.class_eval do
  def create
    variant = Spree::Variant.find(params[:line_item][:variant_id])
    @line_item = order.contents.add(variant, params[:line_item][:quantity])
    if @line_item.save
      @order.ensure_updated_shipments
      respond_with(@order, status: 201, default_template: 'spree/api/orders/show')
    else
      invalid_resource!(@line_item)
    end
  end

  def update
    @line_item = order.line_items.find(params[:id])
    if @order.contents.update_cart(line_items_attributes)
      @order.ensure_updated_shipments
      @line_item.reload
      respond_with(@order, default_template: 'spree/api/orders/show')
    else
      invalid_resource!(@line_item)
    end
  end

  def destroy
    @line_item = order.line_items.find(params[:id])
    variant = Spree::Variant.find(@line_item.variant_id)
    @order.contents.remove(variant, @line_item.quantity)
    @order.ensure_updated_shipments
    respond_with(@order, status: 200, default_template: 'spree/api/orders/show')
  end
end
