class CreateMembers < ActiveRecord::Migration
  def self.up
    create_table :members do |t|
      t.string :login
      t.string :hashed_password
      t.string :salt

      t.string :name

      t.decimal :balance, :precision => 18, :scale => 9, :default => 0

      t.timestamps
    end
    add_index :members, :login
  end

  def self.down
    drop_table :members
  end
end
