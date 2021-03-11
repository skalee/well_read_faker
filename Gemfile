source "https://rubygems.org"

# Specify your gem's dependencies in well_read_faker.gemspec
gemspec

platform :mri_24 do
  gem "coveralls", require: false
end

platform :ruby_19 do
  # Rake 11 drops support for Ruby 1.9, but they don't reflect that in gemspec,
  # hence a following constraint is needed.
  gem "rake", "~> 10.0"
end
