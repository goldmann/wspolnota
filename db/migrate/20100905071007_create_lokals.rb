class CreateLokals < ActiveRecord::Migration
  def self.up
    create_table :lokals do |t|
      t.integer :numer
      t.float :powierzchnia

      t.timestamps
    end
  end

  def self.down
    drop_table :lokals
  end
end
