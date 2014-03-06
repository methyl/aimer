object @user

attributes *user_attributes

node :last_incomplete_order_number do |u|
  u.last_incomplete_spree_order.number if u.last_incomplete_spree_order
end
