# frozen_string_literal: true

require_relative "rdm2/version"

module Rdm2
  class Error < StandardError; end

  class << self
    def init(path, env = nil)
      package = Rdm2::Package.build(path)

      Rdm2::PackageImporter.instance.import(package.name)
    end

    def import_package(package_name, group = nil)
      Rdm2::PackageImporter.instance.import(package.name)
    end

    def list_packages
      project = Rdm2::ProjectLoader.instance.load

      project.packages
    end

    def root
      project = Rdm2::ProjectLoader.instance.load

      project.root
    end
  end
end
