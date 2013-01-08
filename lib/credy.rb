require 'credy/version'
require 'credy/rules'
require 'credy/check'

module Credy

  class CreditCard

    def self.number(options = {})
      valid_rules = Rules.flatten.select do |rule|
        valid = true
        [:country, :type].each do |condition|
          valid = false if options[condition] && options[condition] != rule[condition]
        end
        valid
      end

      return nil if valid_rules.empty?

      rule = valid_rules.sample

      length = rule[:length].is_a?(Array) ? rule[:length].sample : rule[:length]

      begin 
        number = rule[:prefix] 
        (length - number.length).times do
          number = number + (1 + rand(9)).to_s
        end
      end while !Check.luhn number

      {
        number: number,
        type: rule[:type],
        country: rule[:country]
      }
    end
  
  end

end