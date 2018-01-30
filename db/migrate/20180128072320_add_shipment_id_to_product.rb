class AddShipmentIdToProduct < ActiveRecord::Migration[5.1]
  def change
    add_column :products, :shipment_id, :integer
  end
end
