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

ActiveRecord::Schema[8.1].define(version: 2026_02_22_183634) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "dietary_restrictions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_dietary_restrictions_on_name", unique: true
  end

  create_table "diner_restrictions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "dietary_restriction_id", null: false
    t.bigint "diner_id", null: false
    t.datetime "updated_at", null: false
    t.index ["dietary_restriction_id"], name: "index_diner_restrictions_on_dietary_restriction_id"
    t.index ["diner_id", "dietary_restriction_id"], name: "idx_on_diner_id_dietary_restriction_id_bc77af1b8f", unique: true
    t.index ["diner_id"], name: "index_diner_restrictions_on_diner_id"
  end

  create_table "diners", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reservation_diners", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "diner_id", null: false
    t.bigint "reservation_id", null: false
    t.datetime "updated_at", null: false
    t.index ["diner_id"], name: "index_reservation_diners_on_diner_id"
    t.index ["reservation_id", "diner_id"], name: "index_reservation_diners_on_reservation_id_and_diner_id", unique: true
    t.index ["reservation_id"], name: "index_reservation_diners_on_reservation_id"
  end

  create_table "reservations", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "reservation_time", null: false
    t.bigint "table_id", null: false
    t.datetime "updated_at", null: false
    t.index ["table_id", "reservation_time"], name: "index_reservations_on_table_id_and_reservation_time"
    t.index ["table_id"], name: "index_reservations_on_table_id"
  end

  create_table "restaurant_endorsements", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "dietary_restriction_id", null: false
    t.bigint "restaurant_id", null: false
    t.datetime "updated_at", null: false
    t.index ["dietary_restriction_id"], name: "index_restaurant_endorsements_on_dietary_restriction_id"
    t.index ["restaurant_id", "dietary_restriction_id"], name: "idx_restaurant_endorsements_uniqueness", unique: true
    t.index ["restaurant_id"], name: "index_restaurant_endorsements_on_restaurant_id"
  end

  create_table "restaurants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tables", force: :cascade do |t|
    t.integer "capacity", null: false
    t.datetime "created_at", null: false
    t.bigint "restaurant_id", null: false
    t.datetime "updated_at", null: false
    t.index ["restaurant_id"], name: "index_tables_on_restaurant_id"
  end

  add_foreign_key "diner_restrictions", "dietary_restrictions"
  add_foreign_key "diner_restrictions", "diners"
  add_foreign_key "reservation_diners", "diners"
  add_foreign_key "reservation_diners", "reservations"
  add_foreign_key "reservations", "tables"
  add_foreign_key "restaurant_endorsements", "dietary_restrictions"
  add_foreign_key "restaurant_endorsements", "restaurants"
  add_foreign_key "tables", "restaurants"
end
