class Rate < ActiveRecord::Base
  RATES = {
          :central_heating  => { :name => 'Centralne ogrzewanie', :rate_floorage => true, :type => :general },
          :sewage           => { :name => 'Woda i kanalizacja', :rate_water_declaration => true, :type => :general },
          :water_meter      => { :name => 'Licznik wody', :rate_constant => true, :type => :general },
          :garbage          => { :name => 'Wywóz nieczystości', :rate_person_count => true, :type => :general },
          :clean_keeping    => { :name => 'Utrzymanie czystości', :rate_floorage => true, :type => :management_costs },
          :green_keeping    => { :name => 'Utrzymanie zieleni', :rate_floorage => true, :type => :management_costs },
          :manager_salary   => { :name => 'Wynagrodzenie zarządcy', :rate_floorage => true, :type => :management_costs },
          :insurance        => { :name => 'Ubezpieczenie', :rate_floorage => true, :type => :management_costs },
          :inspections      => { :name => 'Przeglądy', :rate_floorage => true, :type => :management_costs }
  }

  validates_presence_of :symbol, :effective_date_of
  validates_numericality_of :value
end
