class CreateAdDynamics < ActiveRecord::Migration
  def self.up
    create_table :ad_dynamics, :id => false do |t|
      t.integer :ad_id
      t.integer :platform_id
      t.integer :city_id
      t.integer :sex
      t.integer :min_age
      t.integer :max_age
      t.integer :ad_type

      t.string :name
      t.string :description
      t.string :link
      t.decimal :click_cost, :precision => 18, :scale => 9
      t.integer :clicks
      t.decimal :ctr, :precision => 18, :scale => 9

      t.decimal :rand, :precision => 18, :scale => 9
    end
  end

  def self.down
    drop_table :ad_dynamics
  end
end
