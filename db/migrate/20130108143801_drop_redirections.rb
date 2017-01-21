class DropRedirections < ActiveRecord::Migration
  def up
    drop_table :redirections
  end

  def down
  end
end
