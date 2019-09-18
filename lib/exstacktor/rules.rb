module Exstacktor
  class Rules
    attr_reader :regex
    attr_reader :exceptions
    RULE_TYPES = %i[exclude include exception].freeze

    def initialize(regex, exceptions=nil)
      @regex = regex
      @exceptions = exceptions
    end
  end
end
