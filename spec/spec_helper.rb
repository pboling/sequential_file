require 'require_relative' # loads rbx-require-relative gem

# For code coverage, must be required before all application / gem / library code.
unless ENV['NOCOVER']
  require 'coveralls'
  Coveralls.wear!
end

require 'sequential_file'

# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'
end

GEM_ROOT = RequireRelative.abs_file.split("spec/spec_helper.rb")[0]
