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

ActiveRecord::Schema[7.2].define(version: 2024_10_03_134000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abstract_web_objects", force: :cascade do |t|
    t.string "object_name", null: false
    t.string "object_key", null: false
    t.string "region", null: false
    t.string "position", null: false
    t.string "shard", default: "Production", null: false
    t.string "url"
    t.integer "user_id"
    t.string "api_key"
    t.integer "actable_id"
    t.string "actable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.integer "server_id"
    t.index ["actable_id"], name: "index_abstract_web_objects_on_actable_id"
    t.index ["actable_type"], name: "index_abstract_web_objects_on_actable_type"
    t.index ["object_key"], name: "index_abstract_web_objects_on_object_key", unique: true
    t.index ["object_name"], name: "index_abstract_web_objects_on_object_name"
    t.index ["region"], name: "index_abstract_web_objects_on_region"
    t.index ["user_id"], name: "index_abstract_web_objects_on_user_id"
  end

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "analyzable_inventories", force: :cascade do |t|
    t.string "inventory_name"
    t.string "description"
    t.integer "owner_perms"
    t.integer "next_perms"
    t.integer "user_id"
    t.integer "server_id"
    t.integer "inventory_type"
    t.string "creator_name"
    t.string "creator_key"
    t.datetime "date_acquired", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["creator_name"], name: "index_analyzable_inventories_on_creator_name"
    t.index ["description"], name: "index_analyzable_inventories_on_description"
    t.index ["inventory_name"], name: "index_analyzable_inventories_on_inventory_name"
    t.index ["inventory_type"], name: "index_analyzable_inventories_on_inventory_type"
    t.index ["user_id"], name: "index_analyzable_inventories_on_user_id"
  end

  create_table "analyzable_transactions", force: :cascade do |t|
    t.integer "amount"
    t.integer "balance"
    t.integer "previous_balance"
    t.integer "user_id"
    t.string "target_key"
    t.string "target_name"
    t.string "description"
    t.integer "transaction_type", default: 0
    t.integer "abstract_web_object_id"
    t.integer "web_object_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "avatars", force: :cascade do |t|
    t.string "avatar_name"
    t.string "avatar_key"
    t.string "display_name"
    t.datetime "rezday"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rezzable_servers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rezzable_terminals", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "rezzable_web_objects", force: :cascade do |t|
  end

  create_table "splits", force: :cascade do |t|
    t.integer "percent"
    t.string "target_key"
    t.string "target_name"
    t.integer "splittable_id"
    t.string "splittable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar_name", default: "", null: false
    t.string "avatar_key", default: "00000000-0000-0000-0000-000000000000", null: false
    t.integer "role", default: 0, null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "expiration_date"
    t.integer "web_object_count", default: 0
    t.integer "web_object_weight", default: 0
    t.integer "account_level", default: 1
    t.integer "object_weight", default: 0
    t.integer "object_count", default: 0
    t.string "business_name"
    t.index ["account_level"], name: "index_users_on_account_level"
    t.index ["avatar_key"], name: "index_users_on_avatar_key", unique: true
    t.index ["avatar_name"], name: "index_users_on_avatar_name", unique: true
    t.index ["expiration_date"], name: "index_users_on_expiration_date"
    t.index ["role"], name: "index_users_on_role"
    t.index ["web_object_count"], name: "index_users_on_web_object_count"
    t.index ["web_object_weight"], name: "index_users_on_web_object_weight"
  end
end
