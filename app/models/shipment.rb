class Shipment < ApplicationRecord
  belongs_to :company
  has_many :shipment_product
  validates :company, presence: true

  enum transport_type: %w[ocean truck plane train]

  def products
    Product.find(product_ids)
  end

  def product_ids
    ShipmentProduct.where(shipment_id: id)
                   .pluck(:product_id)
  end

  def products=(_products); end
end
