RSpec.describe Exstacktor::Ruleset do
  let(:rule1) { Exstacktor::Rules.new(/^.*$/) }
  let(:rule2) { Exstacktor::Rules.new(/^\s.*$/) }

  it 'can create a new exclude ruleset' do
    ruleset = Exstacktor::Ruleset.new([rule1], :exclude)
    expect(ruleset).to be_an Exstacktor::Ruleset
    expect(ruleset.ruleset_type).to eq :exclude
    expect(ruleset.rules.count).to be 1
  end

  it 'can create a new include ruleset' do
    ruleset = Exstacktor::Ruleset.new([rule1], :include)
    expect(ruleset).to be_an Exstacktor::Ruleset
    expect(ruleset.ruleset_type).to eq :include
    expect(ruleset.rules.count).to be 1
  end

  it 'can create a new include ruleset with multiple rules' do
    ruleset = Exstacktor::Ruleset.new([rule1,rule2], :include)
    expect(ruleset).to be_an Exstacktor::Ruleset
    expect(ruleset.ruleset_type).to eq :include
    expect(ruleset.rules.count).to be 2
  end

end
