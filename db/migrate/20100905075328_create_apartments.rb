class CreateApartments < ActiveRecord::Migration
  def self.up
    create_table :apartments do |t|

      t.timestamps
    end
  end

  def self.down
    drop_table :apartments
  end
end
