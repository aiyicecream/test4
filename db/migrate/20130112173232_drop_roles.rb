class DropRoles < ActiveRecord::Migration
  def up
    drop_table :roles
    remove_columns :forums, :writer
    remove_columns :forums, :reader
  end

  def down
    create_table :roles do |t|
      t.string :name
      t.references :user, :forum
      t.timestamps
    end
    add_index :roles, :user_id
    add_index :roles, :forum_id
    add_column :forums, :reader, :string, :default => 'banned'
    add_column :forums, :writer, :string, :default => 'user'
  end
end
