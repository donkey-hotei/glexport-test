class IndexShipmentProductsByShipmentAndProductId < ActiveRecord::Migration[5.1]
  def change
    add_index :shipment_products, :product_id
    add_index :shipment_products, :shipment_id
  end
end
