class DefaultQuanityToZero < ActiveRecord::Migration[5.1]
  def change
    change_column :shipment_products, :quantity, :integer, default: 0
  end
end
