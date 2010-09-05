class CreateLokators < ActiveRecord::Migration
  def self.up
    create_table :lokators do |t|
      t.string :imie
      t.string :nazwisko

      t.timestamps
    end
  end

  def self.down
    drop_table :lokators
  end
end
