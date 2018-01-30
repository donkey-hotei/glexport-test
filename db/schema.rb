# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180128120304) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "sku"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "company_id"
    t.integer "shipment_id"
    t.integer "shipment_product_id"
  end

  create_table "shipment_products", id: :serial, force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "shipment_id", null: false
    t.integer "quantity", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_shipment_products_on_product_id"
    t.index ["shipment_id"], name: "index_shipment_products_on_shipment_id"
  end

  create_table "shipments", force: :cascade do |t|
    t.string "name"
    t.string "international_transportation_mode"
    t.datetime "international_departure_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "transport_type", null: false
    t.integer "company_id"
  end

end
