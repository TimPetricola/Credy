require 'credy/version'
require 'credy/rules'
require 'credy/check'

module Credy

  class CreditCard

    def self.number(options = {})
      rule = Rules.filter(options).sample

      return nil unless rule

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