class CreateLodgers < ActiveRecord::Migration
  def self.up
    create_table :lodgers do |t|
      t.string :first_name
      t.string :last_name
      t.integer :person_count
      t.integer :water_consumption
      t.references :apartment

      t.timestamps
    end
  end

  def self.down
    drop_table :lodgers
  end
end
