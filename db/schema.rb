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

ActiveRecord::Schema.define(version: 20160915141533) do

  create_table "bookmarks", force: :cascade do |t|
    t.integer  "user_id",                   null: false
    t.string   "user_type",     limit: 255
    t.string   "document_id",   limit: 255
    t.string   "title",         limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "document_type", limit: 255
  end

  add_index "bookmarks", ["user_id"], name: "index_bookmarks_on_user_id"

  create_table "checksum_audit_logs", force: :cascade do |t|
    t.string   "generic_file_id", limit: 255
    t.string   "dsid",            limit: 255
    t.string   "version",         limit: 255
    t.integer  "pass"
    t.string   "expected_result", limit: 255
    t.string   "actual_result",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checksum_audit_logs", ["generic_file_id", "dsid"], name: "by_pid_and_dsid"

  create_table "content_blocks", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.text     "value"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "external_key", limit: 255
  end

  create_table "domain_terms", force: :cascade do |t|
    t.string "model", limit: 255
    t.string "term",  limit: 255
  end

  add_index "domain_terms", ["model", "term"], name: "terms_by_model_and_term"

  create_table "domain_terms_local_authorities", id: false, force: :cascade do |t|
    t.integer "domain_term_id"
    t.integer "local_authority_id"
  end

  add_index "domain_terms_local_authorities", ["domain_term_id", "local_authority_id"], name: "dtla_by_ids2"
  add_index "domain_terms_local_authorities", ["local_authority_id", "domain_term_id"], name: "dtla_by_ids1"

  create_table "featured_works", force: :cascade do |t|
    t.integer  "order",                       default: 5
    t.string   "generic_file_id", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "featured_works", ["generic_file_id"], name: "index_featured_works_on_generic_file_id"
  add_index "featured_works", ["order"], name: "index_featured_works_on_order"

  create_table "file_download_stats", force: :cascade do |t|
    t.datetime "date"
    t.integer  "downloads"
    t.string   "file_id",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "file_download_stats", ["file_id"], name: "index_file_download_stats_on_file_id"
  add_index "file_download_stats", ["user_id"], name: "index_file_download_stats_on_user_id"

  create_table "file_view_stats", force: :cascade do |t|
    t.datetime "date"
    t.integer  "views"
    t.string   "file_id",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
  end

  add_index "file_view_stats", ["file_id"], name: "index_file_view_stats_on_file_id"
  add_index "file_view_stats", ["user_id"], name: "index_file_view_stats_on_user_id"

  create_table "follows", force: :cascade do |t|
    t.integer  "followable_id",                               null: false
    t.string   "followable_type", limit: 255,                 null: false
    t.integer  "follower_id",                                 null: false
    t.string   "follower_type",   limit: 255,                 null: false
    t.boolean  "blocked",                     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows"

  create_table "group_users", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: :cascade do |t|
    t.string   "name",         limit: 255
    t.string   "description",  limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "key",          limit: 255
    t.integer  "unit_id"
    t.boolean  "is_unit"
    t.text     "contact_info"
  end

  create_table "import_field_mappings", force: :cascade do |t|
    t.integer  "import_id"
    t.string   "key",        limit: 255
    t.string   "value",      limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "import_field_mappings", ["import_id"], name: "index_import_field_mappings_on_import_id"

  create_table "imported_records", force: :cascade do |t|
    t.integer  "import_id"
    t.string   "generic_file_pid", limit: 255
    t.integer  "csv_row"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "success"
    t.text     "message"
    t.string   "has_image",        limit: 255
    t.string   "has_watermark",    limit: 255
    t.string   "folder_name",      limit: 255
  end

  add_index "imported_records", ["import_id"], name: "index_imported_records_on_import_id"

  create_table "imports", force: :cascade do |t|
    t.string   "name",                        limit: 255
    t.boolean  "includes_headers",                        default: true
    t.integer  "status",                                  default: 0
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "csv_file_name",               limit: 255
    t.string   "csv_content_type",            limit: 255
    t.integer  "csv_file_size"
    t.datetime "csv_updated_at"
    t.string   "admin_collection_id",         limit: 255
    t.string   "server_import_location_name", limit: 255
    t.string   "import_type",                 limit: 255
    t.string   "master_object_type",          limit: 255
    t.string   "rights",                      limit: 255
    t.string   "preservation_level",          limit: 255
    t.string   "visibility"
    t.string   "batch_id"
  end

  add_index "imports", ["user_id"], name: "index_imports_on_user_id"

  create_table "local_authorities", force: :cascade do |t|
    t.string "name", limit: 255
  end

  create_table "local_authority_entries", force: :cascade do |t|
    t.integer "local_authority_id"
    t.string  "label",              limit: 255
    t.string  "uri",                limit: 255
  end

  add_index "local_authority_entries", ["local_authority_id", "label"], name: "entries_by_term_and_label"
  add_index "local_authority_entries", ["local_authority_id", "uri"], name: "entries_by_term_and_uri"

  create_table "mailboxer_conversation_opt_outs", force: :cascade do |t|
    t.integer "unsubscriber_id"
    t.string  "unsubscriber_type", limit: 255
    t.integer "conversation_id"
  end

  add_index "mailboxer_conversation_opt_outs", ["conversation_id"], name: "index_mailboxer_conversation_opt_outs_on_conversation_id"
  add_index "mailboxer_conversation_opt_outs", ["unsubscriber_id", "unsubscriber_type"], name: "index_mailboxer_conversation_opt_outs_on_unsubscriber_id_type"

  create_table "mailboxer_conversations", force: :cascade do |t|
    t.string   "subject",    limit: 255, default: ""
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  create_table "mailboxer_notifications", force: :cascade do |t|
    t.string   "type",                 limit: 255
    t.text     "body"
    t.string   "subject",              limit: 255, default: ""
    t.integer  "sender_id"
    t.string   "sender_type",          limit: 255
    t.integer  "conversation_id"
    t.boolean  "draft",                            default: false
    t.string   "notification_code",    limit: 255
    t.integer  "notified_object_id"
    t.string   "notified_object_type", limit: 255
    t.string   "attachment",           limit: 255
    t.datetime "updated_at",                                       null: false
    t.datetime "created_at",                                       null: false
    t.boolean  "global",                           default: false
    t.datetime "expires"
  end

  add_index "mailboxer_notifications", ["conversation_id"], name: "index_mailboxer_notifications_on_conversation_id"
  add_index "mailboxer_notifications", ["notified_object_id", "notified_object_type"], name: "index_mailboxer_notifications_on_notified_object_id_and_type"
  add_index "mailboxer_notifications", ["sender_id", "sender_type"], name: "index_mailboxer_notifications_on_sender_id_and_sender_type"
  add_index "mailboxer_notifications", ["type"], name: "index_mailboxer_notifications_on_type"

  create_table "mailboxer_receipts", force: :cascade do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type",   limit: 255
    t.integer  "notification_id",                             null: false
    t.boolean  "is_read",                     default: false
    t.boolean  "trashed",                     default: false
    t.boolean  "deleted",                     default: false
    t.string   "mailbox_type",    limit: 25
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
  end

  add_index "mailboxer_receipts", ["notification_id"], name: "index_mailboxer_receipts_on_notification_id"
  add_index "mailboxer_receipts", ["receiver_id", "receiver_type"], name: "index_mailboxer_receipts_on_receiver_id_and_receiver_type"

  create_table "osul_export_all_items_exports", force: :cascade do |t|
    t.string   "fid"
    t.string   "resource_type"
    t.text     "content"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "osul_export_categorize_export_lists", force: :cascade do |t|
    t.string   "fid"
    t.string   "resource_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "osul_export_change_trackers", force: :cascade do |t|
    t.string   "fid"
    t.string   "object_type"
    t.string   "user_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "osul_export_export_generic_file_items", force: :cascade do |t|
    t.string   "fid"
    t.string   "date_uploaded"
    t.string   "identifier"
    t.string   "resource_type"
    t.text     "title"
    t.string   "creator"
    t.string   "contributor"
    t.text     "description"
    t.text     "bibliographic_citation"
    t.text     "tag"
    t.text     "rights"
    t.text     "provenance"
    t.text     "publisher"
    t.text     "date_created"
    t.text     "subject"
    t.text     "language"
    t.text     "based_near"
    t.text     "related_url"
    t.text     "work_type"
    t.text     "spatial"
    t.text     "alternative"
    t.text     "temporal"
    t.text     "format"
    t.text     "staff_notes"
    t.text     "source"
    t.text     "part_of"
    t.string   "preservation_level_rationale"
    t.string   "preservation_level"
    t.string   "collection_identifier"
    t.string   "visibility"
    t.string   "collection_id"
    t.string   "depositor"
    t.string   "handle"
    t.string   "batch_id"
    t.string   "admin_policy_id"
    t.text     "materials"
    t.text     "measurements"
    t.string   "filename"
    t.string   "image_uri"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.string   "unit"
  end

  create_table "osul_export_export_lists", force: :cascade do |t|
    t.string   "fid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "proxy_deposit_requests", force: :cascade do |t|
    t.string   "generic_file_id",   limit: 255,                     null: false
    t.integer  "sending_user_id",                                   null: false
    t.integer  "receiving_user_id",                                 null: false
    t.datetime "fulfillment_date"
    t.string   "status",            limit: 255, default: "pending", null: false
    t.text     "sender_comment"
    t.text     "receiver_comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proxy_deposit_requests", ["receiving_user_id"], name: "index_proxy_deposit_requests_on_receiving_user_id"
  add_index "proxy_deposit_requests", ["sending_user_id"], name: "index_proxy_deposit_requests_on_sending_user_id"

  create_table "proxy_deposit_rights", force: :cascade do |t|
    t.integer  "grantor_id"
    t.integer  "grantee_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "proxy_deposit_rights", ["grantee_id"], name: "index_proxy_deposit_rights_on_grantee_id"
  add_index "proxy_deposit_rights", ["grantor_id"], name: "index_proxy_deposit_rights_on_grantor_id"

  create_table "roles", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "key",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  add_index "roles_users", ["role_id", "user_id"], name: "index_roles_users_on_role_id_and_user_id"
  add_index "roles_users", ["user_id", "role_id"], name: "index_roles_users_on_user_id_and_role_id"

  create_table "searches", force: :cascade do |t|
    t.text     "query_params"
    t.integer  "user_id"
    t.string   "user_type",    limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "searches", ["user_id"], name: "index_searches_on_user_id"

  create_table "single_use_links", force: :cascade do |t|
    t.string   "downloadKey", limit: 255
    t.string   "path",        limit: 255
    t.string   "itemId",      limit: 255
    t.datetime "expires"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subject_local_authority_entries", force: :cascade do |t|
    t.string "label",      limit: 255
    t.string "lowerLabel", limit: 255
    t.string "url",        limit: 255
  end

  add_index "subject_local_authority_entries", ["lowerLabel"], name: "entries_by_lower_label"

  create_table "tinymce_assets", force: :cascade do |t|
    t.string   "file",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trashed_items", force: :cascade do |t|
    t.string   "generic_file_id", limit: 255
    t.string   "visibility",      limit: 255
    t.string   "collection_id",   limit: 255
    t.string   "depositor",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "trophies", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "generic_file_id", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "user_stats", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "date"
    t.integer  "file_views"
    t.integer  "file_downloads"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_stats", ["user_id"], name: "index_user_stats_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "",    null: false
    t.string   "encrypted_password",     limit: 255, default: "",    null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "guest",                              default: false
    t.string   "facebook_handle",        limit: 255
    t.string   "twitter_handle",         limit: 255
    t.string   "googleplus_handle",      limit: 255
    t.string   "display_name",           limit: 255
    t.string   "address",                limit: 255
    t.string   "admin_area",             limit: 255
    t.string   "department",             limit: 255
    t.string   "title",                  limit: 255
    t.string   "office",                 limit: 255
    t.string   "chat_id",                limit: 255
    t.string   "website",                limit: 255
    t.string   "affiliation",            limit: 255
    t.string   "telephone",              limit: 255
    t.string   "avatar_file_name",       limit: 255
    t.string   "avatar_content_type",    limit: 255
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.text     "group_list"
    t.datetime "groups_last_update"
    t.string   "linkedin_handle",        limit: 255
    t.string   "orcid",                  limit: 255
    t.boolean  "currently_osu"
    t.integer  "role_id"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

  create_table "version_committers", force: :cascade do |t|
    t.string   "obj_id",          limit: 255
    t.string   "datastream_id",   limit: 255
    t.string   "version_id",      limit: 255
    t.string   "committer_login", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
