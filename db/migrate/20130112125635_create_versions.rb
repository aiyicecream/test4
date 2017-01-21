class CreateVersions < ActiveRecord::Migration
  def up
    remove_column :forums, :deleted_at 
    remove_column :topics, :deleted_at 
    remove_column :messages, :deleted_at 
    remove_column :users, :deleted_at 
    create_table :versions do |t|
      t.string   :item_type, :null => false
      t.integer  :item_id,   :null => false
      t.string   :event,     :null => false
      t.string   :whodunnit
      t.text     :object
      t.datetime :created_at
    end
    add_index :versions, [:item_type, :item_id]
  end

  def down
    drop_table :versions
    add_column :users, :deleted_at, :datetime
    add_column :forums, :deleted_at, :datetime
    add_column :topics, :deleted_at, :datetime
    add_column :messages, :deleted_at, :datetime
    add_index :forums, :deleted_at
    add_index :topics, :deleted_at
    add_index :messages, :deleted_at
    add_index :users, :deleted_at
  end
end
