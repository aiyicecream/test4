class AddBannerToDomains < ActiveRecord::Migration
  def change
    add_attachment :domains, :banner
  end
end
