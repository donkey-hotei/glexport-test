require "rails_helper"

RSpec.describe Product, :model do
  it "should save with valid attributes" do
    product = build(:product)
    expect(product.valid?).to be true
    expect(product.save).to be true
  end

  describe "as new record" do
    it "should update shipment products table" do
      expect { create(:product) }.to change { ShipmentProduct.count }
        .by 1
    end
  end

  describe "not as new record" do
    let!(:product) { create(:product) }
    it "should not update shipment products table" do
      expect { product.update(description: Faker::Lorem.sentence) }
        .to_not(change { ShipmentProduct.count })
    end
  end
end
