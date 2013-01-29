require 'credy/version'
require 'credy/rules'
require 'credy/check'

module Credy

  class CreditCard

    def self.generate(options = {})
      rule = Rules.filter(options).sample

      return nil unless rule

      length = rule[:length].is_a?(Array) ? rule[:length].sample : rule[:length]
      number = rule[:prefix] 

      # Generate everything except the last digit
      (length - number.length).times do
        number = number + rand(10).to_s
      end

      # Generate the last digit according to luhn algorithm
      l = nil
      digits = (0..9).to_a.map(&:to_s)
      begin
        l = digits.delete digits.sample
      end while !Check.luhn number+l

      number = number+l

      {
        number: number,
        type: rule[:type],
        country: rule[:country]
      }
    end
  
  end

end