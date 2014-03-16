require 'credy/version'
require 'credy/string'
require 'credy/rules'
require 'credy/check'

module Credy

  def self.root
    File.expand_path '../..', __FILE__
  end

  class CreditCard

    # Generate a credit card number
    def self.generate(options = {})
      rule   = find_rule(options) || return
      number = generate_from_rule(rule)

      {
        number:  number,
        type:    rule[:type],
        country: rule[:country]
      }
    end

    # Returns information about a number
    def self.infos(number)
      rules = Rules.all.select do |rule|
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

    def self.find_rule(options = {})
      Rules.filter(options).sample
    end
    private_class_method :find_rule

    def self.complete_number(number)
      # Generates the last digit according to luhn algorithm
      digits = (0..9).map(&:to_s)
      begin
        full = number + digits.delete(digits.sample)
      end while !Check.luhn(full)

      full
    end
    private_class_method :complete_number

    def self.generate_from_rule(rule)
      length = Array(rule[:length]).sample
      number = rule[:prefix]

      # Generates n-1 digits
      (length - number.length - 1).times do
        number += rand(10).to_s
      end

      # Append last digit
      complete_number(number)
    end
    private_class_method :generate_from_rule

  end

end
