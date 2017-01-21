class AddMetaToDomains < ActiveRecord::Migration
  def change
    add_column :domains, :description, :string
    add_column :domains, :keywords, :string
  end
end
