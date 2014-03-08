Spree::Api::OrdersController.class_eval do
  alias_method :old_find_order, :find_order

  def find_order(lock = false)
    old_find_order(lock)
    @order.associate_user!(try_spree_current_user) if @order && @order.total > 0 && try_spree_current_user
  end

  private

  def order_params
    if params.has_key? :order
      params[:order][:payments_attributes] = params[:order][:payments] if params[:order][:payments]
      params[:order][:shipments_attributes] = params[:order][:shipments] if params[:order][:shipments]
      params[:order][:line_items_attributes] = params[:order][:line_items] if params[:order][:line_items]
      params[:order][:ship_address_attributes] = params[:order][:ship_address] if params[:order][:ship_address]
      params[:order][:bill_address_attributes] = params[:order][:bill_address] if params[:order][:bill_address]

      params.require(:order).permit(permitted_order_attributes)
    else
      {}
    end
  end
end
