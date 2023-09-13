require 'set'
require 'benchmark'

class Rdm2::Package::Importer
  include Rdm2::Mixins

  include Rdm2::Deps[
    packages_repo: "package.repo"
  ]

  Contract Or[String, Symbol], KeywordArgs[
    env: Maybe[Symbol]
  ] => nil
  def call(package_name, env: nil)
    package_name = package_name.to_sym
    env ||= Rdm2.current_project.env

    imported = []
    entrypoints = []
    dependency_hash = { name: package_name, only: nil, skip: nil }

    time = Benchmark.realtime do
      import_dependency(dependency_hash, imported, entrypoints, env) do |workdir|
        Rdm2.current_project.loader.push_dir( workdir )
      end

      Rdm2.current_project.loader.setup
      entrypoints.each { require _1 }
    end

    puts "imported package '#{package_name}' with #{imported.size} dependencies in #{'%.2f' % time} seconds for env: #{env}"

    nil
  end

  private

  def import_dependency(dependency_hash, imported, entrypoints, env, &block)
    return if imported.include?(dependency_hash[:name])

    package = packages_repo.find!(dependency_hash[:name])
    if package.nil?
      raise StandardError.new("package '#{package_name}' is not defined for Rdm2 project: '#{Rdm2.current_project.root_path}'")
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

    entrypoints.push( package.entrypoint_file )
    block.call( package.workdir_path )
  end
end