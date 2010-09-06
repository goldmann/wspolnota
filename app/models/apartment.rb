class Apartment < ActiveRecord::Base
  validates_numericality_of :floorage, :number
end
