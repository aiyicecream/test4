class AddUsersCountToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :users_count, :integer, default: 0
  end
end
