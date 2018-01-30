json.call(
  shipment,
  :id,
  :name
)

json.products do
  json.array! shipment.products do |product|
    # json.quanity product.quantity
    json.id product.id
    json.sku product.sku
    json.description product.description
    json.quantity product.quantity
    # TODO: active_shipment_count ?
  end
end
