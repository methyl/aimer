# Spree::Api::CheckoutsController.class_eval do
#   def load_order(lock = false)
#     @order = Spree::Order.lock(lock).find_by!(number: params[:id])
#     raise_insufficient_quantity and return if @order.insufficient_stock_lines.present?
#     @order.state = params[:state] if params[:state]
#     state_callback(:before)
#     @order.associate_user!(try_spree_current_user) if @order && try_spree_current_user
#   end
# end
