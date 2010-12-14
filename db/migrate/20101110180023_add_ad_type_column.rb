class AddAdTypeColumn < ActiveRecord::Migration
  def self.up
    add_column :ads, :ad_type, :integer, :default => 0
  end

  def self.down
    remove_column :ads, :ad_type
  end
end
