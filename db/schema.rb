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

ActiveRecord::Schema[8.1].define(version: 2026_05_04_094432) do
  create_table "crew_rate_card_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "crew_id", null: false
    t.integer "rate_card_item_id", null: false
    t.datetime "updated_at", null: false
    t.index ["crew_id", "rate_card_item_id"], name: "index_crew_rate_card_items_on_crew_id_and_rate_card_item_id", unique: true
    t.index ["crew_id"], name: "index_crew_rate_card_items_on_crew_id"
    t.index ["rate_card_item_id"], name: "index_crew_rate_card_items_on_rate_card_item_id"
  end

  create_table "crew_sites", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "crew_id", null: false
    t.integer "estimate_days"
    t.integer "site_id", null: false
    t.datetime "updated_at", null: false
    t.index ["crew_id", "site_id"], name: "index_crew_sites_on_crew_id_and_site_id", unique: true
    t.index ["crew_id"], name: "index_crew_sites_on_crew_id"
    t.index ["site_id"], name: "index_crew_sites_on_site_id"
  end

  create_table "crews", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.date "joined_date"
    t.decimal "man_day_rate"
    t.string "name"
    t.string "name_th"
    t.string "nickname"
    t.string "phone"
    t.integer "site_id"
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_crews_on_site_id"
  end

  create_table "rate_card_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "currency"
    t.decimal "price"
    t.integer "rate_card_id", null: false
    t.string "role"
    t.string "unit"
    t.datetime "updated_at", null: false
    t.index ["rate_card_id"], name: "index_rate_card_items_on_rate_card_id"
  end

  create_table "rate_cards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.date "effective_from"
    t.date "effective_to"
    t.string "name"
    t.integer "site_id", null: false
    t.datetime "updated_at", null: false
    t.index ["site_id"], name: "index_rate_cards_on_site_id"
  end

  create_table "sites", force: :cascade do |t|
    t.boolean "active"
    t.text "company_address"
    t.string "company_name"
    t.string "company_tax_id"
    t.datetime "created_at", null: false
    t.text "description"
    t.string "name"
    t.datetime "updated_at", null: false
  end

  add_foreign_key "crew_rate_card_items", "crews"
  add_foreign_key "crew_rate_card_items", "rate_card_items"
  add_foreign_key "crew_sites", "crews"
  add_foreign_key "crew_sites", "sites"
  add_foreign_key "crews", "sites"
  add_foreign_key "rate_card_items", "rate_cards"
  add_foreign_key "rate_cards", "sites"
end
