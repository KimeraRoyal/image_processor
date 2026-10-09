# frozen_string_literal: true

require_relative "lib/image_processor/version"

Gem::Specification.new do |spec|
  spec.name          = "image_processor"
  spec.version       = ImageProcessor::VERSION
  spec.author        = "Bridgetown Team"
  spec.email         = "maintainers@bridgetownrb.com"
  spec.summary       = "Sample code for creating new Bridgetown plugins"
  spec.homepage      = "https://github.com/username/image_processor"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r!^(test|script|spec|features|frontend)/!) }
  spec.test_files    = spec.files.grep(%r!^test/!)
  spec.require_paths = ["lib"]
  # Uncomment this if you wish to supply a companion NPM package and/or command features:
  # spec.metadata = {
  #   "npm_add" => "image_processor@#{ImageProcessor::VERSION}",
  #   "bridgetown_features" => "true"
  # }

  spec.required_ruby_version = ">= 3.2"

  spec.add_dependency "bridgetown", ">= 2.0"

  spec.add_runtime_dependency "rmagick", ">= 7.2"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake", ">= 13.0"
  spec.add_development_dependency "rubocop-bridgetown", "~> 0.3"
end
