# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20150502235401) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: true do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "cities", force: true do |t|
    t.string   "name"
    t.integer  "state_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state_code", null: false
    t.string   "city_code",  null: false
  end

  add_index "cities", ["state_id"], name: "index_cities_on_state_id", using: :btree

  create_table "clients", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "company_name"
    t.string   "address"
    t.string   "nit_company_number"
    t.string   "id_document_type"
    t.string   "id_document_number"
    t.string   "client_type"
    t.string   "rucom_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "population_center_id"
    t.string   "email"
  end

  add_index "clients", ["population_center_id"], name: "index_clients_on_population_center_id", using: :btree

  create_table "company_infos", force: true do |t|
    t.string   "nit_number"
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "legal_representative"
    t.string   "id_type_legal_rep"
    t.string   "email"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "provider_id"
    t.string   "id_number_legal_rep"
  end

  create_table "couriers", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "company_name"
    t.string   "address"
    t.string   "nit_company_number"
    t.string   "id_document_type"
    t.string   "id_document_number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "credit_billings", force: true do |t|
    t.integer  "user_id"
    t.integer  "unit"
    t.float    "per_unit_value"
    t.boolean  "payment_flag",        default: false
    t.datetime "payment_date"
    t.float    "discount_percentage", default: 0.0,   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "total_amount",        default: 0.0,   null: false
    t.float    "discount",            default: 0.0,   null: false
  end

  add_index "credit_billings", ["user_id"], name: "index_credit_billings_on_user_id", using: :btree

  create_table "gold_batches", force: true do |t|
    t.text     "parent_batches"
    t.float    "grams"
    t.integer  "grade"
    t.integer  "inventory_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "inventories", force: true do |t|
    t.integer  "purchase_id"
    t.float    "remaining_amount",                null: false
    t.boolean  "status",           default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "inventories", ["purchase_id"], name: "index_inventories_on_purchase_id", using: :btree

  create_table "population_centers", force: true do |t|
    t.string   "name"
    t.decimal  "longitude"
    t.decimal  "latitude"
    t.string   "population_center_type"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "population_center_code", null: false
    t.string   "city_code",              null: false
  end

  add_index "population_centers", ["city_id"], name: "index_population_centers_on_city_id", using: :btree

  create_table "providers", force: true do |t|
    t.string   "document_number"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "phone_number"
    t.string   "address"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "rucom_id"
    t.string   "identification_number_file"
    t.string   "rut_file"
    t.string   "mining_register_file"
    t.string   "photo_file"
    t.string   "email"
    t.integer  "population_center_id"
    t.string   "city"
    t.string   "state"
    t.string   "chamber_commerce_file"
  end

  add_index "providers", ["population_center_id"], name: "index_providers_on_population_center_id", using: :btree

  create_table "purchases", force: true do |t|
    t.integer  "user_id"
    t.integer  "provider_id"
    t.string   "origin_certificate_sequence"
    t.integer  "gold_batch_id"
    t.string   "origin_certificate_file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price"
    t.string   "seller_picture"
    t.text     "code"
    t.boolean  "trazoro",                     default: false, null: false
    t.integer  "sale_id"
  end

  create_table "rucoms", force: true do |t|
    t.string   "idrucom",            limit: 90,                                 null: false
    t.text     "rucom_record"
    t.text     "name"
    t.text     "status"
    t.text     "mineral"
    t.text     "location"
    t.text     "subcontract_number"
    t.text     "mining_permit"
    t.datetime "updated_at",                    default: '2015-04-10 01:25:41'
    t.string   "provider_type"
    t.string   "num_rucom"
  end

  create_table "sales", force: true do |t|
    t.integer  "courier_id"
    t.integer  "client_id"
    t.integer  "user_id"
    t.integer  "gold_batch_id"
    t.float    "grams"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "origin_certificate_file"
  end

  create_table "sold_batches", force: true do |t|
    t.integer  "purchase_id"
    t.float    "grams_picked"
    t.integer  "sale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sold_batches", ["sale_id"], name: "index_sold_batches_on_sale_id", using: :btree

  create_table "states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state_code", null: false
  end

  create_table "users", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "document_number"
    t.date     "document_expedition_date"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.float    "available_credits"
    t.string   "reset_token"
    t.string   "address"
  end

end
