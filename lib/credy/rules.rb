require 'yaml'

module Credy

  class Rules

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

    def self.filter(filters = {})
      flatten.select do |rule|
        valid = true
        [:country, :type].each do |condition|
          valid = false if filters[condition] && filters[condition] != rule[condition]
        end
        valid
      end
    end

  end

end