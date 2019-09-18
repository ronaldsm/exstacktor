RSpec.describe Exstacktor::Rules do
  it 'can create a new rule' do
    rule = Exstacktor::Rules.new(/^.*$/)
    expect(rule).to be_an Exstacktor::Rules
  end

  xit 'can create a new rule with an exception' do
    rule = Exstacktor::Rules.new(/^.*$/)
    expect(rule).to be_an Exstacktor::Rules
  end

  xit 'can create a new rule with multipole exceptions' do
    rule = Exstacktor::Rules.new(/^.*$/)
    expect(rule).to be_an Exstacktor::Rules
  end
end
