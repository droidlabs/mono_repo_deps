# frozen_string_literal: true

require 'rdm2/version'
require 'dry/system'
require 'pry'

module Rdm2
  class Error < StandardError; end

  PROJECT_FILENAME = 'Rdm.packages'
  PACKAGE_FILENAME = 'Package.rb'

  class Container < Dry::System::Container
    use :zeitwerk

    configure do |config|
      config.root = __dir__

      config.component_dirs.add 'rdm2' do |dir|
        dir.namespaces.add nil, key: nil, const: "rdm2"
      end
    end
  end

  # Container.finalize!

  Deps = Container.injector

  class << self
    attr_accessor :project

    def init(path = nil, env = nil)
      path ||= File.dirname(caller_locations.last.path)
      project = Container["project.builder"].call(path)
      package = Container["package.builder"].call(path, project.root)

      Container["package.importer"].call(package.name, from: path, env: env)
    end

    def import_package(package_name, from: nil, env: nil)
      from ||= File.dirname(caller_locations.last.path)

      Container["package.importer"].call(package_name, from: from, env: env)
    end

    def list_packages
      # TODO: not implemented
    end

    def root
      @project.root
    end

    def loader
      @project.loader
    end

    def configs(from = nil)
      path ||= File.dirname(caller_locations.last.path)
      project = Container["project.builder"].call(path)

      Container["config.manager"]
    end
  end
end
