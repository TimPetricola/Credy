require 'yaml'

module Credy

  class Rules

    # Return all the rules from yml files
    def self.raw
      @rules ||= load_rules("#{Credy.root}/data/*.yml")
    end

    # Change hash format to process rules
    def self.all
      rules = []

      raw.each do |type, details|
        # Add general rules
        Array(details['prefix']).each do |prefix|
          rules.push({
            prefix: prefix.to_s,
            length: details['length'],
            type:   type
          })
        end

        # Process each country
        Array(details['countries']).each do |country, prefixes|
          # Add a rule for each prefix
          Array(prefixes).each do |prefix|
            rules.push({
              prefix: prefix.to_s,
              length: details['length'],
              type:   type,
              country: country,
            })
          end
        end

      end

      # Sort by prefix length
      rules.sort { |x, y|  y[:prefix].length <=> x[:prefix].length }
    end

    # Returns rules according to given filters
    def self.filter(filters = {})
      all.select do |rule|
        [:country, :type].each do |condition|
          break false if filters[condition] && filters[condition] != rule[condition]
          true
        end
      end
    end

    def self.load_rules(files)
      {}.tap do |rules|
        Dir.glob(files) do |filename|
          rules.merge! YAML::load IO.read(filename)
        end
      end
    end
    private_class_method :load_rules

  end

end
