class CreatePlatforms < ActiveRecord::Migration
  def self.up
    create_table :platforms do |t|
      t.references :member

      t.string :name

      t.integer :views, :default => 0
      t.integer :clicks, :default => 0
      t.decimal :earnings, :default => 0.0

      t.timestamps
    end
    add_index :platforms, :member_id
  end

  def self.down
    drop_table :platforms
  end
end
