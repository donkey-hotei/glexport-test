FactoryBot.define do
  factory :product do
    company
    shipment

    sku { Faker::Commerce.product_name }
    description { Faker::Lorem.sentence }
  end
end
