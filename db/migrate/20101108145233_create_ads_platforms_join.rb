class CreateAdsPlatformsJoin < ActiveRecord::Migration
  def self.up
    create_table :ads_platforms, :id => false do |t|
      t.references :ad
      t.references :platform
    end
    add_index :ads_platforms, [:ad_id, :platform_id]
  end

  def self.down
    drop_table :ads_platforms
  end
end
