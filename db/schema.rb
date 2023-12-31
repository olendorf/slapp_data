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

ActiveRecord::Schema[7.0].define(version: 2023_07_17_142542) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abstract_web_objects", force: :cascade do |t|
    t.string "object_name"
    t.string "object_key"
    t.string "description"
    t.string "region"
    t.string "position"
    t.string "url"
    t.string "api_key"
    t.integer "user_id"
    t.integer "actable_id"
    t.string "actable_type"
    t.datetime "pinged_at"
    t.integer "major_version"
    t.integer "minor_version"
    t.integer "patch_version"
    t.integer "server_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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

  create_table "rezzable_web_objects", force: :cascade do |t|
    t.string "setting_one", default: "default"
    t.integer "setting_two", default: 0
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
    t.datetime "expiration_date"
    t.index ["avatar_key"], name: "index_users_on_avatar_key", unique: true
    t.index ["avatar_name"], name: "index_users_on_avatar_name", unique: true
    t.index ["role"], name: "index_users_on_role"
  end

end
