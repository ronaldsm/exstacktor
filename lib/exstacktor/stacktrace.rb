module Exstacktor
  class Stacktrace
    attr_reader :raw_stack
    attr_writer :max_stack

    def initialize(raw_stack)
      @raw_stack = raw_stack
    end

    def echo(val = 'default string')
      string
    end
  end
end
