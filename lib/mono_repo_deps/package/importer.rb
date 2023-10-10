require 'benchmark'

class MonoRepoDeps::Package::Importer
  include MonoRepoDeps::Mixins

  include MonoRepoDeps::Deps[
    packages_repo: "package.repo"
  ]

  Contract Or[String, Symbol], KeywordArgs[
    env: Maybe[Symbol]
  ] => nil
  def call(package_name, env: nil)
    package_name = package_name.to_sym
    env ||= MonoRepoDeps.current_project.env

    imported = []
    entrypoints = []
    dependency_hash = { name: package_name, only: nil, skip: nil }

    time = Benchmark.realtime do
      import_dependency(dependency_hash, imported, entrypoints, env)

      MonoRepoDeps.current_project.loader.setup
      entrypoints.each { require _1 }
    end

    puts "imported package '#{package_name}' with #{imported.size} dependencies in #{'%.2f' % time} seconds for env: #{env}"

    nil
  end

  def import_all
    imported = []
    entrypoints = []
    env = MonoRepoDeps.current_project.env

    packages_repo.all
      .map { dependency_hash = { name: _1.name, only: nil, skip: nil } }
      .map { import_dependency(_1, imported, entrypoints, env) }

    MonoRepoDeps.current_project.loader.setup

    entrypoints.each { puts _1; require _1 }
  end

  private

  # TODO: This method is resolving dependencies and importing them, we should split these 2 concerns into 2 methods.
  def import_dependency(dependency_hash, imported, entrypoints, env, &block)
    return if imported.include?(dependency_hash[:name])

    package = packages_repo.find!(dependency_hash[:name])
    if package.nil?
      raise StandardError.new("package '#{package_name}' is not defined for MonoRepoDeps project: '#{MonoRepoDeps.current_project.root_path}'")
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
      }.each { |pd| import_dependency(pd, imported, entrypoints, env, &block) }

    entrypoints.push( package.entrypoint_file ) if File.exist?(package.entrypoint_file)

    MonoRepoDeps.current_project.loader.push_dir(package.workdir_path)
  end
end