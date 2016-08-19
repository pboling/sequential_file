# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'sequential_file/version'

Gem::Specification.new do |spec|
  spec.name          = "sequential_file"
  spec.version       = SequentialFile::VERSION
  spec.authors       = ["Peter Boling"]
  spec.email         = ["peter.boling@gmail.com"]
  spec.description   = %q{Create Files Named Sequentially Intelligently}
  spec.summary       = %q{Create Files Named Sequentially Intelligently}
  spec.homepage      = "http://railsbling.com"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  ############################
  # RUNTIME DEPENDENCIES     #
  ############################
  #
  # NONE!

  ############################
  # DEVELOPMENT DEPENDENCIES #
  ############################

  # Gem dependency manager
  spec.add_development_dependency(%q<bundler>, [">= 1.12"])

  # The ruby workhorse command line tool.
  spec.add_development_dependency(%q<rake>, [">= 11.2.2"])

  # For a test suite.
  # https://github.com/rspec/rspec
  spec.add_development_dependency(%q<rspec>, [">= 3"])

  # Give the test suite super powers (and less verbosity).
  # https://github.com/rspec/rspec
  spec.add_development_dependency(%q<shoulda>, [">= 3.5.0"])
  spec.add_development_dependency(%q<shoulda-matchers>, [">= 1.5.6"])

  # For detecting code smells.
  # https://github.com/troessner/reek
  spec.add_development_dependency(%q<reek>, [">= 1.3.6"])

  # For detecting more code smells.
  # https://github.com/roodi/roodi
  spec.add_development_dependency(%q<roodi>, [">= 3.3.1"])

  # For code coverage
  spec.add_development_dependency "coveralls"

  # Useful to work with relative paths to file, and to derive absolute paths
  spec.add_dependency(%q<rbx-require-relative>, [">= 0.0.9"])

  # For autotest-like sweetness
  spec.add_development_dependency(%q<guard-rspec>, [">= 2.4.0"])

end
