attributes  :id, :name, :cost, :selected, :shipping_method_id
node(:display_cost) { |sr| sr.display_cost.to_s }
node(:cash_on_delivery) { |sr| sr.shipping_method.cash_on_delivery }
