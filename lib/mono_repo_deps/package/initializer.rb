require 'benchmark'

class MonoRepoDeps::Package::Initializer
  include MonoRepoDeps::Mixins

  include MonoRepoDeps::Deps[
    "package.dependency_bypasser",
    packages_repo: "package.repo"
  ]

  Contract Or[String, Symbol], KeywordArgs[
    env: Maybe[Symbol]
  ] => nil
  def call(package_name, env: nil)
    package_name = package_name.to_sym
    env ||= MonoRepoDeps.current_project.env
    packages_import_order = []

    time = Benchmark.realtime do
      packages_import_order = dependency_bypasser
        .call(package_name: package_name, env: env)
        .map { packages_repo.find(_1) }

      packages_import_order
        .each { MonoRepoDeps.current_project.loader.push_dir(_1.workdir_path) }
        .tap { MonoRepoDeps.current_project.loader.setup }

      packages_import_order.each do |package|
        require package.entrypoint_file if File.exists?(package.entrypoint_file)
      end
    end

    puts "imported package '#{package_name}' with #{packages_import_order.size} dependencies in #{'%.2f' % time} seconds for env: #{env}"

    nil
  end

  # def import_all
  #   imported = []
  #   entrypoints = []
  #   env = MonoRepoDeps.current_project.env

  #   packages_repo
  #     .all
  #     .map { dependency_hash = { name: _1.name, only: nil, skip: nil } }
  #     .map { import_dependency(_1, imported, entrypoints, env) }

  #   MonoRepoDeps.current_project.loader.setup

  #   entrypoints.each { puts _1; require _1 }
  # end
end
