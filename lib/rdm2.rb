# frozen_string_literal: true

require 'rdm2/version'
require 'dry/system'
require 'pry'
require "zeitwerk"

module Rdm2
  class Error < StandardError; end

  Zeitwerk::Loader.for_gem.setup

  PROJECT_FILENAME = 'Rdm.packages'
  PACKAGE_FILENAME = 'Package.rb'

  module Rdm2::Mixins
    require 'contracts'
    def self.included(base)
      base.include Contracts::Core
      base.include Contracts::Builtin
    end
  end

  class Container < Dry::System::Container
    configure do |config|
      config.root = __dir__

      config.component_dirs.add 'rdm2' do |dir|
        dir.namespaces.add nil, key: nil, const: "rdm2"
      end
    end
  end

  Deps = Container.injector

  Container.finalize!

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

      new_project = Container["project.builder"].call(path)

      if @current_project && @current_project.root_path == new_project.root_path
        return block.call
      end

      synchronize do
        @current_project = new_project

        block.call
      end
    end

    def synchronize(&block)
      @mutex ||= Mutex.new

      @mutex.synchronize(&block)
    end
  end
end
