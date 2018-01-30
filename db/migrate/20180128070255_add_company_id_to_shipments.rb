class AddCompanyIdToShipments < ActiveRecord::Migration[5.1]
  def change
    add_column :shipments, :company_id, :integer
  end
end
