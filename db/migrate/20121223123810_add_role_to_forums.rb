class AddRoleToForums < ActiveRecord::Migration
  def change
    add_column :forums, :reader, :string, :default => 'banned'
    add_column :forums, :writer, :string, :default => 'user'
  end
end
