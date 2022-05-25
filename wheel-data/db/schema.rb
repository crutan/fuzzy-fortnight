# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_05_24_193034) do
  create_table "cars", force: :cascade do |t|
    t.integer "manufacturer_id", null: false
    t.integer "year"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["manufacturer_id"], name: "index_cars_on_manufacturer_id"
  end

  create_table "manufacturers", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trims", force: :cascade do |t|
    t.string "name"
    t.integer "car_id", null: false
    t.string "bolt_pattern"
    t.integer "min_offset"
    t.integer "max_offset"
    t.integer "min_width"
    t.integer "max_width"
    t.integer "min_diameter"
    t.integer "max_diameter"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["car_id"], name: "index_trims_on_car_id"
  end

  create_table "wheel_vendors", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wheels", force: :cascade do |t|
    t.string "bolt_pattern"
    t.integer "offset"
    t.integer "width"
    t.integer "diameter"
    t.string "vendor_sku"
    t.string "vendor_id"
    t.integer "wheel_vendor_id", null: false
    t.string "finish"
    t.string "brand"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bolt_pattern", "offset", "width", "diameter"], name: "index_wheels_on_bolt_pattern_and_offset_and_width_and_diameter"
    t.index ["wheel_vendor_id"], name: "index_wheels_on_wheel_vendor_id"
  end

  add_foreign_key "cars", "manufacturers"
  add_foreign_key "trims", "cars"
  add_foreign_key "wheels", "wheel_vendors"
end
