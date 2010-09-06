module RatesHelper
  def all_rates
    rates = []

    Rate::RATES.each do |key, value|
      rates << [ value[:name], key ]
    end

    rates.sort
  end

  def rate_unit( rate )
    return 'm2' unless Rate::RATES[rate.symbol.to_sym][:rate_floorage].nil?
    return 'm3' unless Rate::RATES[rate.symbol.to_sym][:rate_water_declaration].nil?
    return 'il. osób' unless Rate::RATES[rate.symbol.to_sym][:rate_person_count].nil?
    return ''
  end
end
