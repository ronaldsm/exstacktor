lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "exstacktor/version"

Gem::Specification.new do |spec|
  spec.name          = 'exstacktor'
  spec.version       = Exstacktor::VERSION
  spec.authors       = ['ronaldsm']
  spec.email         = ['ronaldsm@cisco.com']

  spec.summary       = %q{Parse out the data that you're interested in from a stacktrace}
  spec.description   = %q{Given a stacktrace, parse it to output only the pieces you care about for further analysis/reporting}
  spec.homepage      = 'https://github.com/ronaldsm/exstacktor'
  spec.license       = 'MIT'


  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency 'pry-byebug', '~> 3.4'
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"

end
