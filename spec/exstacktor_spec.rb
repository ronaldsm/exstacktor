RSpec.describe Exstacktor do
  it 'has a version number' do
    expect(Exstacktor::VERSION).not_to be nil
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

  it 'removes lines that match an exclude' do
    stack = Exstacktor::Stacktrace.new
    stack.exclude = [/^.*rspec-core-.*/]
    parsed = stack.parse stacktrace1
    expect(parsed.count).to be 8
  end

  it 'keeps exclude lines that match an include' do
    stack = Exstacktor::Stacktrace.new
    stack.exclude = [/^.*rspec-core-.*/]
    stack.include = [/instance_exec/]
    parsed = stack.parse stacktrace1
    expect(parsed.count).to be 9
  end

  it "can set values through initializer" do
    stack = Exstacktor::Stacktrace.new(exclude: [/^.*rspec-core-.*/], include: [/instance_exec/])
    expect(stack.exclude).to eq [/^.*rspec-core-.*/]
    expect(stack.include).to eq [/instance_exec/]
    parsed = stack.parse stacktrace1
    expect(parsed.count).to be 9
  end

  it 'can remove lines based on multiple exclusions' do
    stack = Exstacktor::Stacktrace.new(exclude: [/^.*rspec-core-.*/, /sendy_events_sender/])
    parsed = stack.parse stacktrace1
    expect(parsed.count).to be 6
  end

  it 'can keep exclude lines based on multiple inclusions' do
    stack = Exstacktor::Stacktrace.new(exclude: [/^.*rspec-core-.*/], include: [/instance_exec/, /hooks.rb:348/])
    parsed = stack.parse stacktrace1
    expect(parsed.count).to be 10
  end


end
