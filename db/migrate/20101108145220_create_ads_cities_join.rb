class CreateAdsCitiesJoin < ActiveRecord::Migration
   def self.up
    create_table :ads_cities, :id => false do |t|
      t.references :ad
      t.references :city
    end
    add_index :ads_cities, [:ad_id, :city_id]
  end

  def self.down
    drop_table :ads_cities
  end
end
