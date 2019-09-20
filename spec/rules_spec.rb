RSpec.describe Exstacktor::Rules do
  regex1 = /^.*$/
  regex2 = /abc/
  regex3 = /cde/

  it 'can create a new rule with no exceptions' do
    rule = Exstacktor::Rules.new(regex1)
    expect(rule).to be_an Exstacktor::Rules
    expect(rule.regex).to eq regex1
    expect(rule.exceptions).to be nil
  end

  it 'can create a new rule with an exception' do
    rule = Exstacktor::Rules.new(regex1, [regex2])
    expect(rule).to be_an Exstacktor::Rules
    expect(rule.regex).to eq regex1
    expect(rule.exceptions.first).to eq regex2
    expect(rule.exceptions.count).to be 1
  end

  it 'can create a new rule with multiple exceptions' do
    rule = Exstacktor::Rules.new(regex1, [regex2, regex3])
    expect(rule).to be_an Exstacktor::Rules
    expect(rule.regex).to eq regex1
    expect(rule.exceptions.first).to eq regex2
    expect(rule.exceptions.count).to be 2
  end
end
