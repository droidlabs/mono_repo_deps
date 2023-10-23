# frozen_string_literal: true

ENV['RUBY_ENV'] = 'test'

require 'mono_repo_deps'
require 'dry/system/stubs'
require 'pry'

MonoRepoDeps::Container.enable_stubs!

RSpec.configure do |config|
  config.after :each do
    MonoRepoDeps::Container.unstub
  end
end

module SpecHelper
  class << self
    def examples_dir
      File.expand_path("../example", __dir__)
    end

    def build_package(name:, deps:)
      MonoRepoDeps::Package.new(
        name: name,
        root_path: 'test',
        package_dirname: 'package',
        dependencies: {
          MonoRepoDeps::Package::DEFAULT_ENV => deps.map { MonoRepoDeps::Package::DependencyDto.new(_1) }
        }
      )
    end
  end
end
