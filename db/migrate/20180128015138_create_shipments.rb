class CreateShipments < ActiveRecord::Migration[5.1]
  def change
    create_table :shipments do |t|
      t.string :name
      t.string :international_transportation_mode
      t.datetime :international_departure_date

      t.timestamps
    end
  end
end
