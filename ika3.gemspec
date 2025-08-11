# frozen_string_literal: true

require_relative 'lib/ika3/version'

Gem::Specification.new do |spec|
  spec.name = 'ika3'
  spec.version = Ika3::VERSION
  spec.authors = ['YutaGoto']
  spec.email = ['you.goto.510@gmail.com']

  spec.summary = 'Splatoon3 weapons information library.'
  spec.description = 'A library to fetch Splatoon 3 weapon information, such as main weapon, sub weapon, and special weapon. Note: This is an unofficial library and not affiliated with Nintendo.'
  spec.homepage = 'https://github.com/YutaGoto/ika3'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.1.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/YutaGoto/ika3'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '>= 6.0.0'
  spec.add_dependency 'faraday', '>= 2.7.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
  spec.metadata['rubygems_mfa_required'] = 'true'
end
