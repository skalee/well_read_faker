require "bundler/setup"
require "pry" unless ENV["CI"] && !ENV["CI"].empty?

begin
  require "coveralls"
  Coveralls.wear! if ENV["CI"] == true
rescue LoadError
end

require "well_read_faker"

RSpec.shared_context "Global helpers" do
  def all_paragraphs_in source
    source.ensure_loaded
    source.instance_variable_get "@text"
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  RSpec::Matchers.define_negated_matcher :exclude, :include

  config.include_context "Global helpers"
end
