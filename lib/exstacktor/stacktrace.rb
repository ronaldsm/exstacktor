module Exstacktor
  class Stacktrace
    attr_reader :raw_stack
    attr_reader :parsed_stack
    attr_accessor :exclude
    attr_accessor :include
    attr_accessor :ruleset
    attr_writer :clean_keep

    def initialize(ruleset: nil, exclude: nil, include: nil)
      @ruleset = ruleset
      @raw_stack = nil
      @parsed_stack = nil
      @exclude = exclude
      @include = include
      @remove = nil
    end


    def parse(stacktrace)
      @raw_stack = stacktrace
      @parsed_stack = []
      @raw_stack.each do |line|
        if keep?(line)
          modified_line = modify_line(line)
          @parsed_stack << modified_line
        end
      end
      @parsed_stack
    end

    def keep?(line)
      return false if @ruleset.nil?

      @ruleset.rules.each do |rule|
        match = line.match(rule.regex)
        # require 'pry-byebug';binding.pry
        exclude = match && @ruleset.ruleset_type == :exclude
        include = match && @ruleset.ruleset_type == :include
        return false if exclude
        return true if include
      end


      # require 'pry-byebug';binding.pry
      false
    end

    def parse_old(stacktrace)
      @raw_stack = stacktrace
      @parsed_stack = []
      @raw_stack.each do |line|
        if exclude_line?(line)
          next unless include_line?(line) # any override to the exclusion?
        end

        modified_line = modify_line(line)
        @parsed_stack << modified_line
      end
      @parsed_stack
    end

    def exclude_line?(line)
      excluded = false
      return false if @exclude.nil?
      return false if @exclude.count.zero?

      @exclude.each do |r|
        excluded = true if line =~ r
      end
      excluded
    end

    def include_line?(line)
      included = false
      return false if @include.nil?
      return false if @include.count.zero?

      @include.each do |r|
        included = true if line =~ r
      end
      included
    end

    def modify_line(line)
      return line if @clean_keep.nil?
      return line if @clean_keep.count.zero?

      @clean_keep.each do |r|
        m = line.match r
        line = m[1] unless m.nil?
      end
      line
    end
  end
end
