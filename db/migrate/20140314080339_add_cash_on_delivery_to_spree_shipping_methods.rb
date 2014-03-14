class AddCashOnDeliveryToSpreeShippingMethods < ActiveRecord::Migration
  def change
    add_column :spree_shipping_methods, :cash_on_delivery, :boolean
  end
end
