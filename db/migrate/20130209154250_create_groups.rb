class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.string :name
      t.string :slug
      t.string :status, :null => false, :default => 'private'
      t.references :user, :null => false
      t.references :domain
      t.timestamps
    end
    create_table :groups_users, :id => false do |t|
      t.references :user, :null => false
      t.references :group, :null => false
    end
    add_index(:groups_users, [:group_id, :user_id], :unique => true)
    add_index :groups, :name
    add_index :groups, :slug
    add_index :groups, :user_id
    add_index :groups, :status
    add_index :groups, :domain_id
  end
end
