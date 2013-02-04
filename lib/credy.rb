require 'credy/version'
require 'credy/string'
require 'credy/rules'
require 'credy/check'

module Credy

  class CreditCard

    # Generate a credit card number
    def self.generate(options = {})

      # Include global rules (not based on country)
      include_global_rules = options[:country].nil?
      rule = Rules.filter(options, include_global_rules).sample

      return nil unless rule

      length = rule[:length].is_a?(Array) ? rule[:length].sample : rule[:length]
      number = rule[:prefix] 

      # Generates n-1 digits
      (length - number.length - 1).times do
        number = number + rand(10).to_s
      end

      # Generates the last digit according to luhn algorithm
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

    # Returns information about a number
    def self.infos(number)
      rules = Rules.flatten(true).select do |rule|
        valid = true

        # Check number of digits
        lengths = rule[:length].is_a?(Array) ? rule[:length] : [rule[:length]]
        valid = false unless lengths.include? number.length

        # Check prefix
        valid = false unless !(number =~ Regexp.new("^#{rule[:prefix]}")).nil?
        valid
      end

      if rules
        rules[0]
      else
        nil
      end
    end

    # Validates a number
    def self.validate(number)
      criterii = {}
      criterii[:luhn] = Check.luhn number
      criterii[:type] = !!self.infos(number)

      valid = criterii.all? { |_, v| v == true }

      {
        valid: valid,
        details: criterii
      }
    end
  
  end

end