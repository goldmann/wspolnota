class Lodger < ActiveRecord::Base
  validates_presence_of :first_name, :last_name

  has_one :apartment
end
