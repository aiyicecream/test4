class CreateAccessControls < ActiveRecord::Migration
  def change
    create_table :access_controls do |t|
      t.references :object, polymorphic: true
      t.references :user, polymorphic: true
      t.string :access

      t.timestamps
    end
    add_index :access_controls, [:object_type, :object_id]
    add_index :access_controls, [:user_type, :user_id]
    add_index :access_controls, :access

    add_column :forums, :acl_view, :string, default: '{"type":"All"}'
    add_column :forums, :acl_read, :string, default: '{"type":"All"}'
    add_column :forums, :acl_write, :string, default: '{"type":"All"}'
    add_column :forums, :acl_admin, :string

    add_column :topics, :acl_view, :string, default: '{"type":"All"}'
    add_column :topics, :acl_read, :string, default: '{"type":"All"}'
    add_column :topics, :acl_write, :string, default: '{"type":"All"}'
    add_column :topics, :acl_admin, :string

    (Forum.all + Topic.all).each do |o|
      %w[view read write].each do |type|
        o.access_controls << AccessControl.new(user_type: 'All', access: type)
      end
    end
  end
end
