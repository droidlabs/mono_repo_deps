require 'set'

class Rdm2::Package::Importer
  include Rdm2::Mixins

  include Rdm2::Deps[
    project_builder: "project.builder",
  ]

  Contract Or[String, Symbol], KeywordArgs[
    from: String,
    env: Maybe[Symbol]
  ] => nil
  def call(package_name, from:, env: nil)
    package_name = package_name.to_sym
    project = project_builder.call(from)
    env ||= project.env

    imported = []
    entrypoints = []
    dependency_hash = { name: package_name, only: nil, skip: nil }

    import_dependency(dependency_hash, imported, entrypoints, project.packages, env, project.package_dir) do |workdir|
      project.loader.push_dir( workdir )
    end

    project.loader.setup
    entrypoints.each { require _1 }

    nil
  end

  private

  def import_dependency(dependency_hash, imported, entrypoints, packages, env, package_dir, &block)
    return if imported.include?(dependency_hash[:name])

    package = packages.detect { |p| p.name == dependency_hash[:name] }
    if package.nil?
      raise StandardError.new("package '#{package_name}' is not defined for Rdm2 project: '#{project.root}'")
    end

    imported.push(dependency_hash[:name])

    package_dependencies = package
      .get_dependencies(env)
      .tap { |pd|
        if dependency_hash[:only]
          pd.select! { dependency_hash[:only].include?(_1[:name]) }
        end

        if dependency_hash[:skip]
          pd.reject! { dependency_hash[:skip].include?(_1[name]) }
        end
      }.each { |pd| import_dependency(pd, imported, entrypoints, packages, env, package_dir, &block) }

    entrypoints.push( package.entrypoint_path(package_dir) )
    block.call( package.workdir_path(package_dir) )
  end
end