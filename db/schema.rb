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

ActiveRecord::Schema[7.2].define(version: 2025_03_23_222313) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "asset_contacts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "assignable_type", null: false
    t.bigint "assignable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignable_type", "assignable_id"], name: "index_asset_contacts_on_assignable"
    t.index ["user_id"], name: "index_asset_contacts_on_user_id"
  end

  create_table "audits", force: :cascade do |t|
    t.integer "auditable_id"
    t.string "auditable_type"
    t.integer "associated_id"
    t.string "associated_type"
    t.integer "user_id"
    t.string "user_type"
    t.string "username"
    t.string "action"
    t.jsonb "audited_changes"
    t.integer "version", default: 0
    t.string "comment"
    t.string "remote_address"
    t.string "request_uuid"
    t.datetime "created_at"
    t.index ["associated_type", "associated_id"], name: "associated_index"
    t.index ["auditable_type", "auditable_id", "version"], name: "auditable_index"
    t.index ["created_at"], name: "index_audits_on_created_at"
    t.index ["request_uuid"], name: "index_audits_on_request_uuid"
    t.index ["user_id", "user_type"], name: "user_index"
  end

  create_table "buildings", force: :cascade do |t|
    t.string "name", null: false
    t.string "number"
    t.string "street", null: false
    t.string "city", null: false
    t.string "state"
    t.string "zip5"
    t.bigint "bbl"
    t.bigint "bin", null: false
    t.integer "borough_code"
    t.integer "community_district_number"
    t.bigint "tax_block_number"
    t.jsonb "has_properties", default: {}
    t.jsonb "numerical_properties", default: {}
    t.bigint "portfolio_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_id"], name: "index_buildings_on_portfolio_id"
  end

  create_table "complaints", force: :cascade do |t|
    t.string "complaint_id", null: false
    t.string "problem_id"
    t.datetime "filed_date"
    t.string "description"
    t.string "category_code"
    t.datetime "disposition_date"
    t.string "disposition_code"
    t.datetime "inspection_date"
    t.integer "state", default: 0
    t.integer "severity"
    t.date "resolved_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "building_id", null: false
    t.index ["building_id"], name: "index_complaints_on_building_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "inspection_rules", force: :cascade do |t|
    t.integer "compliance_item", null: false
    t.string "description"
    t.integer "department"
    t.integer "frequency_in_months", null: false
    t.boolean "based_on_last_inspection"
    t.jsonb "fixed_day_month"
    t.jsonb "cycle_schedule"
    t.jsonb "has_properties", default: {}
    t.jsonb "numerical_properties", default: {}
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["compliance_item"], name: "index_inspection_rules_on_compliance_item", unique: true
  end

  create_table "inspections", force: :cascade do |t|
    t.jsonb "data", default: {}
    t.string "device_id"
    t.date "filing_date"
    t.date "due_date"
    t.integer "state", default: 0
    t.bigint "building_id", null: false
    t.bigint "inspection_rule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_inspections_on_building_id"
    t.index ["inspection_rule_id"], name: "index_inspections_on_inspection_rule_id"
  end

  create_table "leads", force: :cascade do |t|
    t.string "entity_name", null: false
    t.string "chairman_name"
    t.string "agent_name"
    t.string "agent_address"
    t.string "agent_city"
    t.string "agent_state"
    t.string "agent_zip_code"
    t.string "process_name"
    t.string "process_address", null: false
    t.string "process_city", null: false
    t.string "process_state"
    t.string "process_zip_code", null: false
    t.integer "penalty_imposed", null: false
    t.integer "amount_paid"
    t.integer "balance_due"
    t.string "ecb_violation_number"
    t.date "issue_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "portfolios", force: :cascade do |t|
    t.string "name", null: false
    t.string "description"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_portfolios_on_organization_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name", null: false
    t.string "last_name", null: false
    t.string "sms"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "admin"
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count", default: 0
    t.string "title"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invited_by_id"], name: "index_users_on_invited_by_id"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by"
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "violations", force: :cascade do |t|
    t.string "violation_id", null: false
    t.integer "state", default: 0
    t.datetime "issue_date"
    t.integer "severity"
    t.string "violation_type"
    t.string "description"
    t.string "device_number"
    t.string "device_type"
    t.date "resolved_date"
    t.bigint "building_id", null: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_violations_on_building_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "asset_contacts", "users"
  add_foreign_key "buildings", "portfolios"
  add_foreign_key "complaints", "buildings"
  add_foreign_key "inspections", "buildings"
  add_foreign_key "inspections", "inspection_rules"
  add_foreign_key "portfolios", "organizations"
  add_foreign_key "users", "organizations"
  add_foreign_key "violations", "buildings"
end
