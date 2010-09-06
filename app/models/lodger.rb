class Lodger < ActiveRecord::Base
  validates :apartment_id, :presence => true, :uniqueness => true

  validates_presence_of :first_name, :last_name
  validates_numericality_of :person_count, :water_consumption

  belongs_to :apartment
end
