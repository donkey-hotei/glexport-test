class Product < ApplicationRecord
  belongs_to :company
  has_one :shipment_product
  validates :sku, :description, :company, :shipment, presence: true

  after_save :update_shipment_products

  def shipment
    Shipment.find(shipment_id)
  end

  def shipment=(shipment)
    self.shipment_id = shipment.id
  end

  delegate :quantity, to: :shipment_product

  private

  def update_shipment_products
    self.shipment_product = ShipmentProduct.find_or_create_by(shipment_products_params)
  end

  def shipment_products_params
    { shipment_id: shipment_id, product_id: id }
  end
end
