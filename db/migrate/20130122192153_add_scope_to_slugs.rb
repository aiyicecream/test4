class AddScopeToSlugs < ActiveRecord::Migration
  def up
    remove_index :users, :email
    add_index :users, :email
    remove_index :users, :slug
    add_index :users, :slug
    remove_index :forums, :slug
    add_index :forums, :slug
    remove_index :topics, :slug
    add_index :topics, :slug
    remove_index :friendly_id_slugs, [:slug, :sluggable_type]
    add_column :friendly_id_slugs, :scope, :string
    add_index :friendly_id_slugs, [:slug, :sluggable_type, :scope]
  end
end
