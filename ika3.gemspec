# frozen_string_literal: true

require_relative "lib/ika3/version"

Gem::Specification.new do |spec|
  spec.name = "ika3"
  spec.version = Ika3::VERSION
  spec.authors = ["YutaGoto"]
  spec.email = ["you.goto.510@gmail.com"]

  spec.summary = "Splatoon3 weapons information library."
  spec.description = "Splatoon3 weapons information library. This gem provide weapon name, sub, and special. not official"
  spec.homepage = "https://github.com/YutaGoto/ika3"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/YutaGoto/ika3"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "faraday", ">= 2.7.0"
  spec.add_dependency "activesupport", ">= 5.0.0"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
