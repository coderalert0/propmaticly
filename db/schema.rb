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

ActiveRecord::Schema[7.0].define(version: 2025_03_08_191313) do
  create_table "asset_contacts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "assignable_type", null: false
    t.integer "assignable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignable_type", "assignable_id"], name: "index_asset_contacts_on_assignable"
    t.index ["user_id"], name: "index_asset_contacts_on_user_id"
  end

  create_table "bed_bug_inspections", force: :cascade do |t|
    t.string "registration_id"
    t.integer "of_dwelling_units"
    t.integer "infested_dwelling_unit_count"
    t.integer "eradicated_unit_count"
    t.integer "re_infested_dwelling_unit"
    t.datetime "filing_date"
    t.datetime "filing_period_start_date"
    t.datetime "filling_period_end_date"
    t.integer "building_id", null: false
    t.integer "inspection_rule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_bed_bug_inspections_on_building_id"
    t.index ["inspection_rule_id"], name: "index_bed_bug_inspections_on_inspection_rule_id"
  end

  create_table "boiler_inspections", force: :cascade do |t|
    t.string "tracking_number"
    t.string "boiler_id"
    t.string "report_type"
    t.string "applicantfirst_name"
    t.string "applicant_last_name"
    t.string "applicant_license_type"
    t.string "applicant_license_number"
    t.string "boiler_make"
    t.string "boiler_model"
    t.string "pressure_type"
    t.string "inspection_type"
    t.datetime "inspection_date"
    t.string "defects_exist"
    t.integer "lff_45_days"
    t.integer "lff_180_days"
    t.integer "filing_fee"
    t.integer "total_amount_paid"
    t.string "report_status"
    t.integer "building_id", null: false
    t.integer "inspection_rule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_boiler_inspections_on_building_id"
    t.index ["inspection_rule_id"], name: "index_boiler_inspections_on_inspection_rule_id"
  end

  create_table "buildings", force: :cascade do |t|
    t.string "name", null: false
    t.string "number"
    t.string "street", null: false
    t.string "city", null: false
    t.string "state"
    t.string "zip5"
    t.integer "bbl"
    t.integer "bin", null: false
    t.json "has_properties", default: {}
    t.json "numerical_properties", default: {}
    t.integer "portfolio_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_id"], name: "index_buildings_on_portfolio_id"
  end

  create_table "complaints", force: :cascade do |t|
    t.string "complaint_id", null: false
    t.datetime "filed_date"
    t.string "description"
    t.string "category_code"
    t.datetime "disposition_date"
    t.string "disposition_code"
    t.datetime "inspection_date"
    t.integer "state", default: 0
    t.integer "severity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "building_id", null: false
    t.index ["building_id"], name: "index_complaints_on_building_id"
  end

  create_table "cooling_tower_inspections", force: :cascade do |t|
    t.string "system_id"
    t.string "status"
    t.integer "active_equip"
    t.datetime "inspection_date"
    t.string "violation_code"
    t.string "law_section"
    t.string "violation_text"
    t.string "violation_type"
    t.string "citation_text"
    t.string "summons_number"
    t.string "inspection_type"
    t.integer "building_id", null: false
    t.integer "inspection_rule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_cooling_tower_inspections_on_building_id"
    t.index ["inspection_rule_id"], name: "index_cooling_tower_inspections_on_inspection_rule_id"
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

  create_table "elevator_inspections", force: :cascade do |t|
    t.string "device_number"
    t.string "device_type"
    t.string "device_status"
    t.datetime "status_date"
    t.string "equipment_type"
    t.integer "periodic_report_year"
    t.integer "cat1_report_year"
    t.datetime "cat1_latest_report_filed"
    t.datetime "cat5_latest_report_filed"
    t.datetime "periodic_latest_inspection"
    t.integer "building_id", null: false
    t.integer "inspection_rule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_elevator_inspections_on_building_id"
    t.index ["inspection_rule_id"], name: "index_elevator_inspections_on_inspection_rule_id"
  end

  create_table "facade_inspections", force: :cascade do |t|
    t.string "tr6_no"
    t.string "control_no"
    t.string "filing_type"
    t.integer "cycle"
    t.integer "sequence_no"
    t.datetime "submitted_on"
    t.string "current_status"
    t.string "qewi_name"
    t.string "qewi_bus_name"
    t.string "qewi_nys_lic_no"
    t.datetime "qewi_signed_date"
    t.datetime "filing_date"
    t.string "filing_status"
    t.datetime "field_inspection_completed_date"
    t.integer "late_filing_amt"
    t.integer "failure_to_file_amt"
    t.integer "failure_to_collect_amt"
    t.string "comments"
    t.integer "building_id", null: false
    t.integer "inspection_rule_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_facade_inspections_on_building_id"
    t.index ["inspection_rule_id"], name: "index_facade_inspections_on_inspection_rule_id"
  end

  create_table "inspection_rules", force: :cascade do |t|
    t.integer "compliance_item", null: false
    t.string "description"
    t.integer "frequency_in_months", null: false
    t.json "has_properties", default: {}
    t.json "numerical_properties", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "portfolios", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.string "email_address"
    t.integer "organization_id", null: false
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
    t.integer "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.integer "invited_by_id"
    t.integer "invitations_count", default: 0
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
    t.integer "building_id", null: false
    t.string "type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["building_id"], name: "index_violations_on_building_id"
  end

  add_foreign_key "asset_contacts", "users"
  add_foreign_key "bed_bug_inspections", "buildings"
  add_foreign_key "bed_bug_inspections", "inspection_rules"
  add_foreign_key "boiler_inspections", "buildings"
  add_foreign_key "boiler_inspections", "inspection_rules"
  add_foreign_key "buildings", "portfolios"
  add_foreign_key "complaints", "buildings"
  add_foreign_key "cooling_tower_inspections", "buildings"
  add_foreign_key "cooling_tower_inspections", "inspection_rules"
  add_foreign_key "elevator_inspections", "buildings"
  add_foreign_key "elevator_inspections", "inspection_rules"
  add_foreign_key "facade_inspections", "buildings"
  add_foreign_key "facade_inspections", "inspection_rules"
  add_foreign_key "portfolios", "organizations"
  add_foreign_key "users", "organizations"
  add_foreign_key "violations", "buildings"
end
