FactoryBot.define do
  factory :shipment do
    company

    name { Faker::StarTrek.character }
    transport_type { Shipment.transport_types.keys.sample }
  end

  trait :with_products do
    after(:create) do |shipment|
      shipment.update(
        products: create_list(:product, 3, shipment_id: shipment.id)
      )
    end
  end
end
