# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2019_08_08_093533) do

  create_table "accesses", force: :cascade do |t|
    t.integer "user_id"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_accesses_on_group_id"
    t.index ["user_id"], name: "index_accesses_on_user_id"
  end

  create_table "actions", force: :cascade do |t|
    t.integer "issue_id"
    t.integer "advice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["advice_id"], name: "index_actions_on_advice_id"
    t.index ["issue_id"], name: "index_actions_on_issue_id"
  end

  create_table "advices", force: :cascade do |t|
    t.string "subject"
    t.string "description"
    t.boolean "read"
    t.boolean "completed"
    t.string "advice_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "answers", force: :cascade do |t|
    t.string "field_type"
    t.string "text"
    t.string "value"
    t.integer "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "assesment_id"
    t.index ["assesment_id"], name: "index_answers_on_assesment_id"
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "assesments", force: :cascade do |t|
    t.datetime "date"
    t.string "name"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "maturity_framework_id"
    t.index ["maturity_framework_id"], name: "index_assesments_on_maturity_framework_id"
    t.index ["team_id"], name: "index_assesments_on_team_id"
  end

  create_table "cards", force: :cascade do |t|
    t.integer "workflow_id"
    t.string "name"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["workflow_id"], name: "index_cards_on_workflow_id"
  end

  create_table "change_logs", force: :cascade do |t|
    t.datetime "created"
    t.string "fromString"
    t.string "toString"
    t.integer "issue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "displayName"
    t.string "fieldtype"
    t.string "avatar"
    t.index ["issue_id"], name: "index_change_logs_on_issue_id"
  end

  create_table "comments", force: :cascade do |t|
    t.integer "advice_id"
    t.integer "actor_id"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "components", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "components_sprints", id: false, force: :cascade do |t|
    t.integer "sprint_id"
    t.integer "component_id"
    t.index ["component_id"], name: "index_components_sprints_on_component_id"
    t.index ["sprint_id"], name: "index_components_sprints_on_sprint_id"
  end

  create_table "configs", force: :cascade do |t|
    t.integer "user_id"
    t.integer "setting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["setting_id"], name: "index_configs_on_setting_id"
    t.index ["user_id"], name: "index_configs_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.integer "priority"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "issues", force: :cascade do |t|
    t.string "key", null: false
    t.string "issuetype"
    t.string "summary"
    t.integer "customfield_11802", default: 0
    t.string "customfield_11382", default: ""
    t.string "description"
    t.string "priority"
    t.string "components"
    t.string "status"
    t.string "project"
    t.string "assignee"
    t.datetime "created"
    t.datetime "updated"
    t.datetime "resolutiondate"
    t.integer "sprint_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "issueicon"
    t.string "priorityicon"
    t.string "statusname"
    t.string "projectavatar"
    t.string "assigneeavatar"
    t.datetime "inprogress"
    t.datetime "released"
    t.integer "issuetypeid"
    t.float "cycle_time"
    t.index ["sprint_id"], name: "index_issues_on_sprint_id"
  end

  create_table "levels", force: :cascade do |t|
    t.string "name"
    t.integer "maturity_framework_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["maturity_framework_id"], name: "index_levels_on_maturity_framework_id"
  end

  create_table "maturity_frameworks", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notifications", force: :cascade do |t|
    t.integer "recipient_id"
    t.integer "actor_id"
    t.datetime "read_at"
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "action"
  end

  create_table "postits", force: :cascade do |t|
    t.integer "user_id"
    t.string "text"
    t.integer "position"
    t.integer "dots"
    t.integer "comments"
    t.integer "retrospective_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["retrospective_id"], name: "index_postits_on_retrospective_id"
  end

  create_table "project_infos", force: :cascade do |t|
    t.string "key"
    t.string "name"
    t.string "icon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "q_stages", force: :cascade do |t|
    t.string "name"
    t.integer "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "level_id"
    t.index ["level_id"], name: "index_q_stages_on_level_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "question"
    t.string "help_text"
    t.boolean "allow_comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "q_stage_id"
    t.index ["q_stage_id"], name: "index_questions_on_q_stage_id"
  end

  create_table "retrospectives", force: :cascade do |t|
    t.string "name"
    t.integer "position"
    t.integer "team_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["team_id"], name: "index_retrospectives_on_team_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "site"
    t.string "base_path"
    t.string "context"
    t.boolean "debug"
    t.string "signature_method"
    t.string "key_file"
    t.string "consumer_key"
    t.boolean "oauth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.binary "key_data"
    t.string "login"
    t.string "password"
    t.string "name"
  end

  create_table "sprints", force: :cascade do |t|
    t.string "name"
    t.integer "stories"
    t.integer "bugs"
    t.integer "closed_points"
    t.integer "remaining_points"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "enddate"
    t.boolean "active"
    t.integer "remainingstories", default: 0
    t.date "start_date"
    t.integer "sprint_id"
    t.index ["team_id"], name: "index_sprints_on_team_id"
  end

  create_table "team_advices", force: :cascade do |t|
    t.integer "team_id"
    t.integer "advice_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["advice_id"], name: "index_team_advices_on_advice_id"
    t.index ["team_id"], name: "index_team_advices_on_team_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.integer "max_capacity"
    t.integer "current_capacity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "tmf_process", default: 0
    t.integer "tmf_value", default: 0
    t.integer "tmf_quality", default: 0
    t.string "project"
    t.integer "board_id"
    t.string "avatar"
    t.string "estimated"
    t.integer "setting_id"
    t.integer "project_info_id"
    t.string "board_type"
    t.index ["project_info_id"], name: "index_teams_on_project_info_id"
    t.index ["setting_id"], name: "index_teams_on_setting_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
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
    t.string "name"
    t.string "extuser", default: "Guest"
    t.string "displayName", default: "Guest"
    t.boolean "active"
    t.string "avatar", default: "/images/tmf_1.png"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workflows", force: :cascade do |t|
    t.string "open"
    t.string "backlog"
    t.string "wip"
    t.string "testing"
    t.string "done"
    t.string "flagged"
    t.integer "cycle_time"
    t.integer "lead_time"
    t.integer "setting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.integer "position"
    t.index ["setting_id"], name: "index_workflows_on_setting_id"
  end

  add_foreign_key "accesses", "groups"
  add_foreign_key "accesses", "users"
  add_foreign_key "actions", "advices"
  add_foreign_key "actions", "issues"
  add_foreign_key "answers", "assesments"
  add_foreign_key "answers", "questions"
  add_foreign_key "assesments", "maturity_frameworks"
  add_foreign_key "assesments", "teams"
  add_foreign_key "cards", "workflows"
  add_foreign_key "change_logs", "issues"
  add_foreign_key "components_sprints", "components"
  add_foreign_key "components_sprints", "sprints"
  add_foreign_key "configs", "settings"
  add_foreign_key "configs", "users"
  add_foreign_key "issues", "sprints"
  add_foreign_key "levels", "maturity_frameworks"
  add_foreign_key "postits", "retrospectives"
  add_foreign_key "q_stages", "levels"
  add_foreign_key "questions", "q_stages"
  add_foreign_key "retrospectives", "teams"
  add_foreign_key "sprints", "teams"
  add_foreign_key "team_advices", "advices"
  add_foreign_key "team_advices", "teams"
  add_foreign_key "teams", "project_infos"
  add_foreign_key "teams", "settings"
  add_foreign_key "workflows", "settings"
end
