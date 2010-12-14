class CreateCampaigns < ActiveRecord::Migration
  def self.up
    create_table :campaigns do |t|
      t.references :member
      
      t.string :name
      t.integer :status, :default => 0

      t.decimal :balance, :precision => 18, :scale => 9, :default => 0.0
      t.decimal :limit, :precision => 18, :scale => 9, :default => -1.0
      t.decimal :day_limit, :precision => 18, :scale => 9, :default => -1.0

      t.timestamps
    end
    add_index :campaigns, :member_id
  end

  def self.down
    drop_table :campaigns
  end
end
