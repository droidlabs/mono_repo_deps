# frozen_string_literal: true

ENV['RUBY_ENV'] = 'test'

require 'mono_repo_deps'
require 'dry/system/stubs'
require 'pry'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before :suite do
    MonoRepoDeps::Container.enable_stubs!
  end
end

def examples_dir
  File.expand_path("../example", __dir__)
end
