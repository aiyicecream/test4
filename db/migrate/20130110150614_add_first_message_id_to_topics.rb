class AddFirstMessageIdToTopics < ActiveRecord::Migration
  def change
    add_column :topics, :first_message_id, :integer, :references => :messages
    add_index :topics, :first_message_id
  end
end
