class CreateStatisticEntries < ActiveRecord::Migration
  def self.up
    create_table :statistic_entries do |t|
      t.references :platform
      t.references :ad

      t.integer :year
      t.integer :day
      t.integer :month

      t.decimal :expenses
      t.integer :views
      t.integer :clicks

      t.timestamps
    end
    add_index :statistic_entries, ["platform_id", "ad_id", "day", "month", "year"]
  end

  def self.down
    drop_table :statistic_entries
  end
end
