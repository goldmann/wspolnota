class CreateRates < ActiveRecord::Migration
  def self.up
    create_table :rates do |t|
      t.string :symbol
      t.float :value
      t.date :effective_date_of

      t.timestamps
    end
  end

  def self.down
    drop_table :rates
  end
end
