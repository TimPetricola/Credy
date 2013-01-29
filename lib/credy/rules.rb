require 'yaml'

module Credy

  class Rules

    # Return all the rules from yml files
    def self.all
      @rules ||= begin
        rules = {}
        Dir.glob 'data/*.yml' do |filename|
          r = YAML::load IO.read(filename)
          rules.merge! r
        end
        rules
      end
    end

    # Change hash format to process rules
    def self.flatten
      rules = []
      all.each do |type, details|
        details['countries'].each do |country, prefixes|
          prefixes = [prefixes] unless prefixes.is_a? Array
          prefixes.each do |prefix|
            rules.push({
              prefix: prefix.to_s,
              length: details['length'],
              type: type,
              country: country,
            })
          end
        end
      end
      rules
    end

    # Returns rules according to given filters
    def self.filter(filters = {})
      flatten.select do |rule|
        [:country, :type].each do |condition|
          break false if filters[condition] && filters[condition] != rule[condition]
          true
        end
      end
    end

  end

end