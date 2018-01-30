require "rails_helper"

RSpec.describe Shipment, :model do
  it "should have a valid factory" do
    # i.e: has a valid factory
    shipment = build(:shipment)
    expect(shipment.valid?).to be true
    expect(shipment.save).to be true
  end

  describe "shipment factory trait :with_products" do
    it "should save shipment with products" do
      shipment = create(:shipment, :with_products)
      expect(shipment.products).to_not be_empty
    end
  end
end
