class AddForumsCountToDomain < ActiveRecord::Migration
  def change
    add_column :domains, :forums_count, :integer, default: 0
  end
end
