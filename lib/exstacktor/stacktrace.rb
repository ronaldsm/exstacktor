module Exstacktor
  class Stacktrace
    attr_reader :raw_stack
    attr_reader :parsed_stack
    attr_accessor :exclude
    attr_accessor :include
    attr_writer :clean_keep

    def initialize(exclude: nil, include: nil)
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

      #method/line
      # m = line.match(/^.*(\/\w+:\d+):.*/)
      # line = m[1] unless m.nil?
      # /api_vulnerabilities_filters_spec.rb:62:in


      line
    end
  end
end
