require "bundler/setup"
require "well_read_faker"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  RSpec::Matchers.define_negated_matcher :exclude, :include
end
