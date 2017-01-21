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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130407145952) do

  create_table "access_controls", :force => true do |t|
    t.integer  "object_id"
    t.string   "object_type"
    t.integer  "user_id"
    t.string   "user_type"
    t.string   "access"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "access_controls", ["access"], :name => "index_access_controls_on_access"
  add_index "access_controls", ["object_type", "object_id"], :name => "index_access_controls_on_object_type_and_object_id"
  add_index "access_controls", ["user_type", "user_id"], :name => "index_access_controls_on_user_type_and_user_id"

  create_table "bookmarks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.integer  "message_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "domain_id"
  end

  add_index "bookmarks", ["message_id"], :name => "index_bookmarks_on_message_id"
  add_index "bookmarks", ["topic_id"], :name => "index_bookmarks_on_topic_id"
  add_index "bookmarks", ["user_id"], :name => "index_bookmarks_on_user_id"

  create_table "domains", :force => true do |t|
    t.string   "name"
    t.string   "title"
    t.string   "url"
    t.text     "content"
    t.text     "rendered_content"
    t.string   "theme",               :default => "#B82010"
    t.text     "css"
    t.integer  "messages_count",      :default => 0,         :null => false
    t.integer  "topics_count",        :default => 0,         :null => false
    t.integer  "users_count",         :default => 0,         :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
    t.string   "banner_file_name"
    t.string   "banner_content_type"
    t.integer  "banner_file_size"
    t.datetime "banner_updated_at"
    t.string   "description"
    t.string   "keywords"
    t.integer  "forums_count",        :default => 0
  end

  add_index "domains", ["name"], :name => "index_domains_on_name"

  create_table "follows", :force => true do |t|
    t.integer  "followable_id"
    t.string   "followable_type"
    t.integer  "user_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "domain_id"
  end

  add_index "follows", ["followable_id"], :name => "index_follows_on_followable_id"
  add_index "follows", ["followable_type"], :name => "index_follows_on_followable_type"
  add_index "follows", ["user_id"], :name => "index_follows_on_user_id"

  create_table "forums", :force => true do |t|
    t.string   "name",                           :null => false
    t.text     "content"
    t.integer  "topics_count",    :default => 0, :null => false
    t.integer  "messages_count",  :default => 0, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "slug"
    t.integer  "position"
    t.integer  "follows_count",   :default => 0, :null => false
    t.integer  "parent_id"
    t.integer  "domain_id"
    t.string   "acl_view"
    t.string   "acl_read"
    t.string   "acl_write"
    t.string   "acl_admin"
    t.integer  "last_message_id"
  end

  add_index "forums", ["last_message_id"], :name => "index_forums_on_last_message_id"
  add_index "forums", ["parent_id"], :name => "index_forums_on_parent_id"
  add_index "forums", ["position"], :name => "index_forums_on_position"
  add_index "forums", ["slug"], :name => "index_forums_on_slug"

  create_table "friendly_id_slugs", :force => true do |t|
    t.string   "slug",                         :null => false
    t.integer  "sluggable_id",                 :null => false
    t.string   "sluggable_type", :limit => 40
    t.datetime "created_at"
    t.string   "scope"
  end

  add_index "friendly_id_slugs", ["slug", "sluggable_type", "scope"], :name => "index_friendly_id_slugs_on_slug_and_sluggable_type_and_scope"
  add_index "friendly_id_slugs", ["sluggable_id"], :name => "index_friendly_id_slugs_on_sluggable_id"
  add_index "friendly_id_slugs", ["sluggable_type"], :name => "index_friendly_id_slugs_on_sluggable_type"

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.string   "status",      :default => "private", :null => false
    t.integer  "user_id",                            :null => false
    t.integer  "domain_id",                          :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "users_count", :default => 0
  end

  add_index "groups", ["domain_id"], :name => "index_groups_on_domain_id"
  add_index "groups", ["name"], :name => "index_groups_on_name"
  add_index "groups", ["slug"], :name => "index_groups_on_slug"
  add_index "groups", ["status"], :name => "index_groups_on_status"
  add_index "groups", ["user_id"], :name => "index_groups_on_user_id"

  create_table "groups_users", :id => false, :force => true do |t|
    t.integer "user_id",  :null => false
    t.integer "group_id", :null => false
  end

  add_index "groups_users", ["group_id", "user_id"], :name => "index_groups_users_on_group_id_and_user_id", :unique => true

  create_table "messages", :force => true do |t|
    t.text     "content"
    t.integer  "user_id"
    t.integer  "topic_id"
    t.integer  "forum_id"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.text     "rendered_content"
    t.integer  "updater_id"
    t.integer  "follows_count",           :default => 0, :null => false
    t.integer  "domain_id"
    t.string   "attachment_file_name"
    t.string   "attachment_content_type"
    t.integer  "attachment_file_size"
    t.datetime "attachment_updated_at"
  end

  add_index "messages", ["forum_id"], :name => "index_messages_on_forum_id"
  add_index "messages", ["topic_id"], :name => "index_messages_on_topic_id"
  add_index "messages", ["updater_id"], :name => "index_messages_on_updater_id"
  add_index "messages", ["user_id"], :name => "index_messages_on_user_id"

  create_table "notifications", :force => true do |t|
    t.integer  "user_id"
    t.integer  "message_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "read",       :default => false
    t.integer  "domain_id"
    t.boolean  "sent",       :default => false
    t.integer  "topic_id"
    t.integer  "forum_id"
  end

  add_index "notifications", ["forum_id"], :name => "index_notifications_on_forum_id"
  add_index "notifications", ["message_id"], :name => "index_notifications_on_message_id"
  add_index "notifications", ["read"], :name => "index_notifications_on_read"
  add_index "notifications", ["topic_id"], :name => "index_notifications_on_topic_id"
  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "small_messages", :force => true do |t|
    t.integer  "message_id"
    t.integer  "user_id"
    t.integer  "topic_id"
    t.integer  "forum_id"
    t.string   "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "domain_id"
  end

  add_index "small_messages", ["forum_id"], :name => "index_small_messages_on_forum_id"
  add_index "small_messages", ["message_id"], :name => "index_small_messages_on_message_id"
  add_index "small_messages", ["topic_id"], :name => "index_small_messages_on_topic_id"
  add_index "small_messages", ["user_id"], :name => "index_small_messages_on_user_id"

  create_table "topics", :force => true do |t|
    t.string   "name",                                :null => false
    t.integer  "user_id"
    t.integer  "forum_id"
    t.integer  "messages_count",   :default => 0,     :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.string   "slug"
    t.integer  "views_count",      :default => 0,     :null => false
    t.integer  "viewer_id"
    t.integer  "last_message_id"
    t.boolean  "pinned",           :default => false
    t.integer  "follows_count",    :default => 0,     :null => false
    t.integer  "first_message_id"
    t.integer  "domain_id"
    t.string   "acl_view"
    t.string   "acl_read"
    t.string   "acl_write"
    t.string   "acl_admin"
  end

  add_index "topics", ["first_message_id"], :name => "index_topics_on_first_message_id"
  add_index "topics", ["forum_id"], :name => "index_topics_on_forum_id"
  add_index "topics", ["last_message_id"], :name => "index_topics_on_last_message_id"
  add_index "topics", ["pinned"], :name => "index_topics_on_pinned"
  add_index "topics", ["slug"], :name => "index_topics_on_slug"
  add_index "topics", ["updated_at"], :name => "index_topics_on_updated_at"
  add_index "topics", ["user_id"], :name => "index_topics_on_user_id"
  add_index "topics", ["viewer_id"], :name => "index_topics_on_viewer_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",    :null => false
    t.string   "encrypted_password",     :default => "",    :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.integer  "messages_count",         :default => 0,     :null => false
    t.integer  "topics_count",           :default => 0,     :null => false
    t.string   "name"
    t.date     "birthdate"
    t.string   "gender"
    t.string   "location"
    t.string   "website"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "slug"
    t.boolean  "human",                  :default => false
    t.boolean  "sysadmin",               :default => false
    t.integer  "notifications_count",    :default => 0
    t.integer  "follows_count",          :default => 0,     :null => false
    t.datetime "last_post_at"
    t.string   "facebook"
    t.string   "google"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "failed_attempts",        :default => 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.integer  "domain_id"
    t.string   "locale"
    t.boolean  "notify",                 :default => true
  end

  add_index "users", ["birthdate"], :name => "index_users_on_birthdate"
  add_index "users", ["confirmation_token"], :name => "index_users_on_confirmation_token", :unique => true
  add_index "users", ["created_at"], :name => "index_users_on_created_at"
  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["facebook"], :name => "index_users_on_facebook"
  add_index "users", ["gender"], :name => "index_users_on_gender"
  add_index "users", ["google"], :name => "index_users_on_google"
  add_index "users", ["location"], :name => "index_users_on_location"
  add_index "users", ["messages_count"], :name => "index_users_on_messages_count"
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["slug"], :name => "index_users_on_slug"
  add_index "users", ["topics_count"], :name => "index_users_on_topics_count"
  add_index "users", ["unlock_token"], :name => "index_users_on_unlock_token", :unique => true
  add_index "users", ["updated_at"], :name => "index_users_on_updated_at"
  add_index "users", ["website"], :name => "index_users_on_website"

  create_table "versions", :force => true do |t|
    t.string   "item_type",  :null => false
    t.integer  "item_id",    :null => false
    t.string   "event",      :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

end
