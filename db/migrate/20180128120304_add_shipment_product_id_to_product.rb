class AddShipmentProductIdToProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :shipment_product_id, :integer
  end
end
