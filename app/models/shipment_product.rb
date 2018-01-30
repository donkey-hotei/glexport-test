class ShipmentProduct < ApplicationRecord
  belongs_to :shipment
  belongs_to :product

  accepts_nested_attributes_for :product

  validates :shipment_id, :product_id, presence: true

  before_save :update_quantity

  private

  def update_quantity
    self.quantity += 1
  end
end
