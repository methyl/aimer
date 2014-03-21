object @user

attributes *user_attributes

node :last_incomplete_order_number do |u|
  u.last_incomplete_spree_order.number if u.last_incomplete_spree_order
end

node :address do |u|
  if order = u.orders.where('ship_address_id is not null').last
    partial "spree/api/addresses/show", object: order.ship_address
  end
end
