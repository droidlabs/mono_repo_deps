# frozen_string_literal: true

require 'mono_repo_deps/version'
require 'dry/system'
require 'benchmark'
require "zeitwerk"
require 'pry'

module MonoRepoDeps
  class Error < StandardError; end

  PROJECT_FILENAME = 'MonoRepoConfig.rb'
  PACKAGE_FILENAME = 'Package.rb'

  module Mixins
    def self.included(base)
      require 'sorbet-runtime'

      base.extend T::Sig
    end
  end

  class Container < Dry::System::Container
    use :env, inferrer: -> { ENV.fetch("RUBY_ENV", :production).to_sym }
    # use :logging

    configure do |config|
      config.root = __dir__

      config.component_dirs.add 'mono_repo_deps' do |dir|
        dir.namespaces.add nil, key: nil, const: "mono_repo_deps"
      end
    end
  end

  Deps = Container.injector

  Container.finalize! unless Container.env == :test

  Zeitwerk::Loader
    .for_gem
    .tap(&:setup)
    .tap(&:eager_load)

  class << self
    attr_accessor :current_project

    def init_package(package_name = nil, from: caller_locations.first.path, env: nil, prevent_eager_load: false)
      sync_current_project!(from) do
        package_name ||= Container["package.builder"].call(from, current_project.root_path, current_project.package_dirname).name
        env ||= current_project.env

        Container["package.initializer"].call(package_name, env: env, prevent_eager_load: prevent_eager_load)
      end
    end

    def root(from = caller_locations.first.path)
      sync_current_project!(from) do
        current_project.root_path
      end
    end

    def tasks(from = caller_locations.first.path)
      sync_current_project!(from) do
        Container["task.manager"]
      end
    end

    def loader(from = caller_locations.first.path)
      sync_current_project!(from) do
        current_project.loader
      end
    end

    def configs(from = caller_locations.first.path)
      sync_current_project!(from) do
        Container["config.manager"]
      end
    end

    def packages(from = caller_locations.first.path)
      sync_current_project!(from) do
        Container["package.repo"]
      end
    end

    def sync_current_project!(path, &block)
      path = File.expand_path(path)
      path = File.dirname(path) unless File.directory?(path)

      root = Container['project.find_root'].call(path)

      if @current_project && @current_project.root_path == root
        return block.call
      end

      synchronize do
        @current_project = Container["project.initializer"].call(path)

        block.call
      end
    end

    def synchronize(&block)
      @mutex ||= Mutex.new

      @mutex.synchronize(&block)
    end
  end
end
