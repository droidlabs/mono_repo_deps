# frozen_string_literal: true

require_relative "lib/rdm2/version"

Gem::Specification.new do |spec|
  spec.name = "rdm2"
  spec.version = Rdm2::VERSION
  spec.authors = ["Nikita Kononov"]
  spec.email = ["vocrsz@gmail.com"]

  spec.summary = "TODO: Write a short summary, because RubyGems requires one."
  spec.description = "TODO: Write a longer description or delete this line."
  spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "contracts", '0.17.0'

  spec.add_dependency "dry-auto_inject", "~> 0.9.0"
  spec.add_dependency "dry-core", "~> 0.8.1"
  spec.add_dependency "dry-configurable", "~> 0.16.1"
  spec.add_dependency "dry-container", "~> 0.10.1"

  # spec.add_dependency "thor"
  # spec.add_dependency "cli-ui", '2.1.0'
  # spec.add_dependency "net-ssh"
  # spec.add_dependency "tty-prompt"

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
