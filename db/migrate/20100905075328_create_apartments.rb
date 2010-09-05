class CreateApartments < ActiveRecord::Migration
  def self.up
    create_table :apartments do |t|
      t.integer :number
      t.float :area

      t.timestamps
    end
  end

  def self.down
    drop_table :apartments
  end
end
