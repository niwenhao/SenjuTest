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

ActiveRecord::Schema.define(version: 20160927090109) do

  create_table "senju_envs", force: :cascade do |t|
    t.string   "logonUser"
    t.string   "hostName"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "senju_jobs", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "command"
    t.integer  "expected"
    t.integer  "senjuEnv_id"
    t.string   "task_type"
    t.integer  "task_id"
    t.string   "preExec_type"
    t.integer  "preExec_id"
    t.string   "postExec_type"
    t.integer  "postExec_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["postExec_type", "postExec_id"], name: "index_senju_jobs_on_postExec_type_and_postExec_id"
    t.index ["preExec_type", "preExec_id"], name: "index_senju_jobs_on_preExec_type_and_preExec_id"
    t.index ["senjuEnv_id"], name: "index_senju_jobs_on_senjuEnv_id"
    t.index ["task_type", "task_id"], name: "index_senju_jobs_on_task_type_and_task_id"
  end

  create_table "senju_nets", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "senjuEnv_id"
    t.string   "preExec_type"
    t.integer  "preExec_id"
    t.string   "postExec_type"
    t.integer  "postExec_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["postExec_type", "postExec_id"], name: "index_senju_nets_on_postExec_type_and_postExec_id"
    t.index ["preExec_type", "preExec_id"], name: "index_senju_nets_on_preExec_type_and_preExec_id"
    t.index ["senjuEnv_id"], name: "index_senju_nets_on_senjuEnv_id"
  end

  create_table "senju_successions", force: :cascade do |t|
    t.string   "left_type"
    t.integer  "left_id"
    t.string   "right_type"
    t.integer  "right_id"
    t.string   "task_type"
    t.integer  "task_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["left_type", "left_id"], name: "index_senju_successions_on_left_type_and_left_id"
    t.index ["right_type", "right_id"], name: "index_senju_successions_on_right_type_and_right_id"
    t.index ["task_type", "task_id"], name: "index_senju_successions_on_task_type_and_task_id"
  end

  create_table "senju_trigers", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.string   "node"
    t.string   "path"
    t.string   "postExec_type"
    t.integer  "postExec_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["postExec_type", "postExec_id"], name: "index_senju_trigers_on_postExec_type_and_postExec_id"
  end

  create_table "shell_tasks", force: :cascade do |t|
    t.string   "command"
    t.integer  "expected"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
