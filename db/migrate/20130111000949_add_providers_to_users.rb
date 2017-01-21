class AddProvidersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :facebook, :string
    add_column :users, :google, :string
    add_index :users, :facebook
    add_index :users, :google
  end
end
