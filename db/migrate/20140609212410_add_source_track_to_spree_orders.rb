class AddSourceTrackToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :source_track, :string
  end
end
