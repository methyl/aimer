Spree::Api::LineItemsController.class_eval do
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
end
