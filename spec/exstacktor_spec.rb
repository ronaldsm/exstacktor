RSpec.describe Exstacktor do
  it 'has a version number' do
    expect(Exstacktor::VERSION).not_to be nil
  end
  abc_rule = Exstacktor::Rules.new(/abc/)
  ghi_rule = Exstacktor::Rules.new(/ghi/)

  stacktrace2 = [
    'abc def',
    'abc ghi',
    'abc jkl',
    'def ghi',
    'def jkl',
    'def mno',
    'xyz uvw',
    'xyz rst'
  ]

  it 'can include lines based on a rule' do
    # ruleset = [Exstacktor::Ruleset.new(/abc/, :include)]
    ruleset = Exstacktor::Ruleset.new([abc_rule], :include)
    stack = Exstacktor::Stacktrace.new(ruleset: ruleset)
    parsed = stack.parse stacktrace2
    expect(parsed.count).to eq 3
  end

  it 'can include lines based on multiple rules' do
    ruleset = Exstacktor::Ruleset.new([abc_rule, ghi_rule], :include)
    stack = Exstacktor::Stacktrace.new(ruleset: ruleset)
    parsed = stack.parse stacktrace2
    expect(parsed.count).to eq 4
  end

  it 'can handle an exception to an include rule' do
    rule_with_exception = Exstacktor::Rules.new(/abc/, [/ghi/])
    ruleset = Exstacktor::Ruleset.new([rule_with_exception], :include)
    stack = Exstacktor::Stacktrace.new(ruleset: ruleset)
    parsed = stack.parse stacktrace2
    expect(parsed.count).to eq 2
  end

  xit 'can exclude lines based on a rule' do
    ruleset = Exstacktor::Ruleset.new([abc_rule], :exclude)
    stack = Exstacktor::Stacktrace.new(ruleset: ruleset)
    parsed = stack.parse stacktrace2
    expect(parsed.count).to eq 5
  end


  stacktrace1 = [
    "/data/go-agent/pipelines/ec2_automation/lib/sendy_events_sender.rb:38:in `rescue in send_and_wait_for_event'",
    "/data/agent/pipelines/ec2/lib/sendy_events_sender.rb:32:in `send_and_wait_for_event'",
    "/data/agent/pipelines/ec2/regression_tests/new_overview/helpers/vulnerabilities_spec_helper.rb:71:in `send_vulnerabilities_event'",
    "/data/agent/pipelines/ec2/spec/api/api_filters_spec.rb:62:in `block in send_vulnerabilities'",
    "/data/agent/pipelines/ec2/spec/api/api_filters_spec.rb:60:in `each'",
    "/data/agent/pipelines/ec2/spec/api/api_filters_spec.rb:60:in `send_vulnerabilities'",
    "/data/agent/pipelines/ec2/spec/api/api_filters_spec.rb:143:in `block (3 levels) in \u003ctop (required)\u003e'",
    "/data/tmp/ec2_automation/vendor/bundle/ruby/2.5.0/gems/rspec-core-3.8.2/lib/rspec/core/hook.rb:348:in `instance_exec'",
    "/data/tmp/ec2_automation/vendor/bundle/ruby/2.5.0/gems/rspec-core-3.8.2/lib/rspec/core/hooks.rb:348:in `run'",
    "/data/tmp/ec2_automation/vendor/bundle/ruby/2.5.0/gems/rspec-core-3.8.2/lib/rspec/core/hooks.rb:507:in `block in run_owned_hooks_for'",
    "bin/rspec:29:in `load'"
  ]

  xit 'removes lines that match an exclude' do
    stack = Exstacktor::Stacktrace.new
    stack.exclude = [/^.*rspec-core-.*/]
    parsed = stack.parse stacktrace1
    expect(parsed.count).to be 8
  end

  xit 'keeps exclude lines that match an include' do
    stack = Exstacktor::Stacktrace.new
    stack.exclude = [/^.*rspec-core-.*/]
    stack.include = [/instance_exec/]
    parsed = stack.parse stacktrace1
    expect(parsed.count).to be 9
  end

  xit "can set values through initializer" do
    stack = Exstacktor::Stacktrace.new(exclude: [/^.*rspec-core-.*/], include: [/instance_exec/])
    expect(stack.exclude).to eq [/^.*rspec-core-.*/]
    expect(stack.include).to eq [/instance_exec/]
    parsed = stack.parse stacktrace1
    expect(parsed.count).to be 9
  end

  xit 'can remove lines based on multiple exclusions' do
    stack = Exstacktor::Stacktrace.new(exclude: [/^.*rspec-core-.*/, /sendy_events_sender/])
    parsed = stack.parse stacktrace1
    expect(parsed.count).to be 6
  end

  xit 'can keep exclude lines based on multiple inclusions' do
    stack = Exstacktor::Stacktrace.new(exclude: [/^.*rspec-core-.*/], include: [/instance_exec/, /hooks.rb:348/])
    parsed = stack.parse stacktrace1
    expect(parsed.count).to be 10
  end

end
