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

ActiveRecord::Schema.define(version: 20160808203611) do

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
    t.string   "code"
  end

  add_index "cities", ["state_id"], name: "index_cities_on_state_id", using: :btree

  create_table "companies", force: true do |t|
    t.string   "nit_number"
    t.string   "name"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "email"
    t.string   "phone_number"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "chamber_of_commerce_file"
    t.boolean  "external",                 default: false, null: false
    t.string   "rut_file"
    t.string   "mining_register_file"
    t.integer  "legal_representative_id"
    t.string   "address"
  end

  add_index "companies", ["legal_representative_id"], name: "index_companies_on_legal_representative_id", using: :btree

  create_table "countries", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
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

  create_table "documents", force: true do |t|
    t.string   "file"
    t.string   "type"
    t.string   "documentable_id"
    t.string   "documentable_type"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "documents", ["documentable_id"], name: "index_documents_on_documentable_id", using: :btree

  create_table "gold_batches", force: true do |t|
    t.float    "fine_grams"
    t.integer  "grade"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "extra_info"
    t.string   "goldomable_type"
    t.integer  "goldomable_id"
    t.boolean  "sold",            default: false
  end

  add_index "gold_batches", ["goldomable_id"], name: "index_gold_batches_on_goldomable_id", using: :btree

  create_table "inventories", force: true do |t|
    t.float    "remaining_amount",                null: false
    t.boolean  "status",           default: true, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "inventories", ["user_id"], name: "index_inventories_on_user_id", using: :btree

  create_table "offices", force: true do |t|
    t.string   "name"
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "city_id"
    t.string   "address"
  end

  create_table "profiles", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "document_number"
    t.string   "phone_number"
    t.float    "available_credits"
    t.string   "address"
    t.string   "rut_file"
    t.string   "photo_file"
    t.text     "mining_authorization_file"
    t.boolean  "legal_representative"
    t.text     "id_document_file"
    t.string   "nit_number"
    t.integer  "city_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "profiles", ["city_id"], name: "index_profiles_on_city_id", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "purchases", force: true do |t|
    t.string   "origin_certificate_sequence"
    t.string   "origin_certificate_file"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price"
    t.string   "seller_picture"
    t.text     "code"
    t.boolean  "trazoro",                     default: false, null: false
    t.integer  "seller_id"
    t.integer  "inventory_id"
  end

  add_index "purchases", ["seller_id"], name: "index_purchases_on_seller_id", using: :btree

  create_table "roles", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", force: true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "roles_users", ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id", unique: true, using: :btree

  create_table "rucoms", force: true do |t|
    t.string   "rucom_number"
    t.string   "name"
    t.string   "original_name"
    t.string   "minerals"
    t.string   "location"
    t.string   "status"
    t.string   "provider_type"
    t.string   "rucomeable_type"
    t.integer  "rucomeable_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "rucoms", ["rucomeable_id"], name: "index_rucoms_on_rucomeable_id", using: :btree

  create_table "sales", force: true do |t|
    t.integer  "courier_id"
    t.string   "code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "price"
    t.boolean  "trazoro",      default: false, null: false
    t.integer  "inventory_id"
    t.integer  "buyer_id"
  end

  add_index "sales", ["buyer_id"], name: "index_sales_on_buyer_id", using: :btree
  add_index "sales", ["inventory_id"], name: "index_sales_on_inventory_id", using: :btree

  create_table "settings", force: true do |t|
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sold_batches", force: true do |t|
    t.float    "grams_picked"
    t.integer  "sale_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gold_batch_id"
  end

  add_index "sold_batches", ["gold_batch_id"], name: "index_sold_batches_on_gold_batch_id", using: :btree
  add_index "sold_batches", ["sale_id"], name: "index_sold_batches_on_sale_id", using: :btree

  create_table "states", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "country_id"
    t.string   "code"
  end

  create_table "users", force: true do |t|
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "password_digest"
    t.string   "reset_token"
    t.integer  "office_id"
    t.boolean  "external",           default: false, null: false
    t.string   "registration_state"
  end

end
