# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'well_read_faker/version'

Gem::Specification.new do |spec|
  spec.name          = "well_read_faker"
  spec.version       = WellReadFaker::VERSION
  spec.authors       = ["Sebastian Skałacki"]
  spec.email         = ["skalee@gmail.com"]

  spec.summary       = %q{Returns random fragments of Iliad or other book.}
  spec.description   = %q{A replacement for various lorem ipsum generators.}
  spec.homepage      = "https://github.com/skalee/well_read_faker"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.14", "< 3"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.5"
end
