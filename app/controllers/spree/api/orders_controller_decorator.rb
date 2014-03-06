Spree::Api::OrdersController.class_eval do
  alias_method :old_find_order, :find_order

  def find_order(lock = false)
    old_find_order(lock)
    @order.associate_user!(try_spree_current_user) if @order && try_spree_current_user
  end
end
