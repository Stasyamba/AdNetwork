class CreateAds < ActiveRecord::Migration
  def self.up
    create_table :ads do |t|
      t.references :campaign

      t.integer :min_age, :default => 0
      t.integer :max_age, :default => 999
      t.integer :sex, :default => 0
      t.integer :city, :default => 0

      t.decimal :click_cost, :precision => 18, :scale => 9, :default => 1.0
      t.integer :views, :default => 0
      t.integer :clicks, :default => 0
      t.decimal :expenses, :precision => 18, :scale => 9, :default => 0.0

      t.integer :status, :default => 0

      t.string :link, :limit => 255
      t.string :image_url, :limit => 255
      t.string :name, :limit => 50
      t.string :description, :limit => 100

      t.timestamps
    end
    add_index :ads, :campaign_id
  end

  def self.down
    drop_table :ads
  end
end
