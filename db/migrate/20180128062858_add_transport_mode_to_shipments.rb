class AddTransportModeToShipments < ActiveRecord::Migration[5.1]
  def change
    add_column :shipments, :transport_type, :integer, null: false
  end
end
