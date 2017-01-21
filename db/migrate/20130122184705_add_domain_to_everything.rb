class AddDomainToEverything < ActiveRecord::Migration
  def change
    add_column :forums, :domain_id, :integer, :references => :domains
    add_column :users, :domain_id, :integer, :references => :domains
    add_column :topics, :domain_id, :integer, :references => :domains
    add_column :messages, :domain_id, :integer, :references => :domains
    add_column :small_messages, :domain_id, :integer, :references => :domains
    add_column :bookmarks, :domain_id, :integer, :references => :domains
    add_column :follows, :domain_id, :integer, :references => :domains
    add_column :notifications, :domain_id, :integer, :references => :domains
  end
end
