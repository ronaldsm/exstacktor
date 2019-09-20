RSpec.describe Exstacktor do
  it 'has a version number' do
    expect(Exstacktor::VERSION).not_to be nil
  end
  abc_rule = Exstacktor::Rules.new(/abc/)
  ghi_rule = Exstacktor::Rules.new(/ghi/)

  stacktrace1 = [
    'abc def',
    'abc ghi',
    'abc jkl',
    'def ghi',
    'def jkl',
    'def mno',
    'xyz uvw',
    'xyz rst'
  ]
  context 'including loglines' do
    it 'can include lines based on a rule' do
      # ruleset = [Exstacktor::Ruleset.new(/abc/, :include)]
      ruleset = Exstacktor::Ruleset.new([abc_rule], :include)
      stack = Exstacktor::Stacktrace.new(ruleset: ruleset)
      parsed = stack.parse stacktrace1
      expect(parsed.count).to eq 3
    end

    it 'can include lines based on multiple rules' do
      ruleset = Exstacktor::Ruleset.new([abc_rule, ghi_rule], :include)
      stack = Exstacktor::Stacktrace.new(ruleset: ruleset)
      parsed = stack.parse stacktrace1
      expect(parsed.count).to eq 4
      expect(parsed.first).to eq 'abc def'
    end

    it 'can handle an exception to an include rule' do
      rule_with_exception = Exstacktor::Rules.new(/abc/, [/ghi/])
      ruleset = Exstacktor::Ruleset.new([rule_with_exception], :include)
      stack = Exstacktor::Stacktrace.new(ruleset: ruleset)
      parsed = stack.parse stacktrace1
      expect(parsed.count).to eq 2
      expect(parsed[0]).to eq 'abc def'
      expect(parsed[1]).to eq 'abc jkl'
    end

    it 'can handle multiple exceptions to an include rule' do
      rule_with_exception = Exstacktor::Rules.new(/abc/, [/ghi/,/def/])
      ruleset = Exstacktor::Ruleset.new([rule_with_exception], :include)
      stack = Exstacktor::Stacktrace.new(ruleset: ruleset)
      parsed = stack.parse stacktrace1
      expect(parsed.count).to eq 1
      expect(parsed[0]).to eq 'abc jkl'
    end
  end

  context 'excluding loglines' do
    it 'can exclude lines based on a rule' do
      ruleset = Exstacktor::Ruleset.new([abc_rule], :exclude)
      stack = Exstacktor::Stacktrace.new(ruleset: ruleset)
      parsed = stack.parse stacktrace1
      expect(parsed.count).to eq 5
    end

    it 'can include lines based on multiple rules' do
      ruleset = Exstacktor::Ruleset.new([abc_rule, ghi_rule], :exclude)
      stack = Exstacktor::Stacktrace.new(ruleset: ruleset)
      parsed = stack.parse stacktrace1
      expect(parsed.count).to eq 4
      expect(parsed.first).to eq 'def jkl'
    end

    it 'can handle an exception to an exclude rule' do
      rule_with_exception = Exstacktor::Rules.new(/abc/, [/ghi/])
      ruleset = Exstacktor::Ruleset.new([rule_with_exception], :exclude)
      stack = Exstacktor::Stacktrace.new(ruleset: ruleset)
      parsed = stack.parse stacktrace1
      expect(parsed.count).to eq 6
      expect(parsed[0]).to eq 'abc ghi'
      expect(parsed[1]).to eq 'def ghi'
    end

    it 'can handle multiple exceptions to an exclude rule' do
      rule_with_exception = Exstacktor::Rules.new(/abc/, [/ghi/,/def/])
      ruleset = Exstacktor::Ruleset.new([rule_with_exception], :exclude)
      stack = Exstacktor::Stacktrace.new(ruleset: ruleset)
      parsed = stack.parse stacktrace1
      expect(parsed.count).to eq 7
      expect(parsed[0]).to eq 'abc def'
      expect(parsed[1]).to eq 'abc ghi'
      expect(parsed[2]).to eq 'def ghi'

    end
  end
end
