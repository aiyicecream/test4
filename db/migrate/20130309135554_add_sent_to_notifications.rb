class AddSentToNotifications < ActiveRecord::Migration
  def change
    add_column :notifications, :sent, :boolean, default: false
    add_column :notifications, :topic_id, :integer
    add_column :notifications, :forum_id, :integer
    add_index :notifications, :topic_id
    add_index :notifications, :forum_id
  end
end
