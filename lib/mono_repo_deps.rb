# frozen_string_literal: true

require 'mono_repo_deps/version'
require 'dry/system'
require 'pry'
require 'benchmark'
require "zeitwerk"

module MonoRepoDeps
  class Error < StandardError; end

  PROJECT_FILENAME = 'MonoRepoConfig.rb'
  PACKAGE_FILENAME = 'Package.rb'

  module MonoRepoDeps::Mixins
    require 'contracts'
    def self.included(base)
      base.include Contracts::Core
      base.include Contracts::Builtin
    end
  end

  class Container < Dry::System::Container
    configure do |config|
      config.root = __dir__

      config.component_dirs.add 'mono_repo_deps' do |dir|
        dir.namespaces.add nil, key: nil, const: "mono_repo_deps"
      end
    end
  end

  Deps = Container.injector

  Container.finalize!

  Zeitwerk::Loader
    .for_gem
    .tap { _1.setup }
    .tap { _1.eager_load }

  class << self
    attr_accessor :current_project

    def import_by_path(from = caller_locations.first.path, env: nil)
      for_current_project(from) do
        Container["package.builder"].call(from, current_project.root_path, current_project.package_dir).then do |package|
          Container["package.importer"].call(package.name, env: env)
        end
      end
    end

    def import_package(package_name, from: caller_locations.first.path, env: nil)
      for_current_project(from) do
        Container["package.importer"].call(package_name, env: env)
      end
    end

    def root(from = caller_locations.first.path)
      for_current_project(from) do
        current_project.root_path
      end
    end

    def tasks(from = caller_locations.first.path)
      for_current_project(from) do
        Container["task.manager"]
      end
    end

    # TODO: find project in registry
    def loader(from = caller_locations.first.path)
      for_current_project(from) do
        current_project.loader
      end
    end

    def configs(from = caller_locations.first.path)
      for_current_project(from) do
        Container["config.manager"]
      end
    end

    def packages(from = caller_locations.first.path)
      for_current_project(from) do
        Container["package.repo"]
      end
    end

    def for_current_project(path, &block)
      path = File.expand_path(path)
      path = File.dirname(path) unless File.directory?(path)

      root = Container['project.find_root'].call(path)

      if @current_project && @current_project.root_path == root
        return block.call
      end

      synchronize do
        @current_project = Container["project.builder"].call(path)

        block.call
      end
    end

    def synchronize(&block)
      @mutex ||= Mutex.new

      @mutex.synchronize(&block)
    end
  end
end
