# frozen_string_literal: true

require_relative "lib/mono_repo_deps/version"

Gem::Specification.new do |spec|
  spec.name = "mono_repo_deps"
  spec.version = MonoRepoDeps::VERSION
  spec.authors = ["Nikita Kononov"]
  spec.email = ["vocrsz@gmail.com"]

  spec.summary = "A Ruby gem for efficiently managing dependencies within a monorepo."
  spec.description   = <<-DESC
    MonoRepoDeps is a powerful tool designed to streamline the process of splitting code into separate packages
    within a monorepository. It provides a flexible and easy-to-use solution for managing dependencies between
    packages, making it ideal for large-scale projects with complex codebases.

    Key Features:
    - Simplifies the organization of code in a monorepo structure.
    - Manages dependencies seamlessly between different packages.
    - Enhances collaboration and code sharing among teams working on interconnected components.
    - Offers a straightforward and customizable configuration for your monorepo setup.

    How to Use:
    - Install the gem using `gem install MonoRepoDeps`.
    - Configure MonoRepoDeps with your monorepo specifications.
    - Enjoy a more efficient and organized development workflow.

    Visit the official documentation for detailed instructions and examples.

    GitHub Repository: https://github.com/droidlabs/MonoRepoDeps
  DESC
  spec.homepage = "https://github.com/droidlabs/mono_repo_deps"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.7.0"

  # spec.metadata["allowed_push_host"] = "Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/droidlabs/mono_repo_deps"
  spec.metadata["changelog_uri"] = "https://github.com/droidlabs/mono_repo_deps"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(/\Aexe\//) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'sorbet-static-and-runtime', "~> 0.5.11105"

  spec.add_dependency "dry-auto_inject", "~> 1.0.1"
  spec.add_dependency "dry-core", "~> 1.0.0"
  spec.add_dependency "dry-configurable", "~> 1.0.1"
  spec.add_dependency "dry-container", "~> 0.11.0"
  spec.add_dependency "dry-system", "~> 1.0.1"

  spec.add_dependency "zeitwerk", "~> 2.6.12"

  spec.add_dependency "thor"

  spec.add_development_dependency "bundler", "~> 2.2"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "pry"
end
