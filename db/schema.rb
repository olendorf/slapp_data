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

ActiveRecord::Schema[7.1].define(version: 2024_06_01_214550) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "abstract_web_objects", force: :cascade do |t|
    t.string "object_name", null: false
    t.string "object_key", null: false
    t.string "owner_name", null: false
    t.string "owner_key", null: false
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
    t.index ["actable_id"], name: "index_abstract_web_objects_on_actable_id"
    t.index ["actable_type"], name: "index_abstract_web_objects_on_actable_type"
    t.index ["object_key"], name: "index_abstract_web_objects_on_object_key", unique: true
    t.index ["object_name"], name: "index_abstract_web_objects_on_object_name"
    t.index ["owner_key"], name: "index_abstract_web_objects_on_owner_key"
    t.index ["owner_name"], name: "index_abstract_web_objects_on_owner_name"
    t.index ["region"], name: "index_abstract_web_objects_on_region"
    t.index ["user_id"], name: "index_abstract_web_objects_on_user_id"
  end

  create_table "rezzable_web_objects", force: :cascade do |t|
  end

  create_table "users", force: :cascade do |t|
    t.string "avatar_name", default: "", null: false
    t.string "avatar_key", default: "00000000-0000-0000-0000-000000000000", null: false
    t.integer "role", default: 0, null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["avatar_key"], name: "index_users_on_avatar_key", unique: true
    t.index ["avatar_name"], name: "index_users_on_avatar_name", unique: true
  end

end
