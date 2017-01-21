class AddLastMessageIdToForums < ActiveRecord::Migration
  def change
    add_column :forums, :last_message_id, :integer
    add_index :forums, :last_message_id
    remove_column :forums, :updater_id
    remove_column :topics, :updater_id
    Forum.all.each{|f|
      f.update_column :last_message_id, Message.where(:forum_id => f.children.map(&:id) << f.id).last.try(:id)
    }
  end
end
