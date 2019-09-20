module Exstacktor
  class Ruleset
    attr_reader :rules
    attr_reader :ruleset_type

    RULESET_TYPES = %i[exclude include].freeze

    def initialize(rules, ruleset_type)
      raise ArgumentError, "invalid ruleset type: #{ruleset_type}" unless RULESET_TYPES.include? ruleset_type
      raise ArgumentError, "must provide an array of rules" unless rules.first.class == Exstacktor::Rules

      @rules = rules
      @ruleset_type = ruleset_type
    end

  end
end
