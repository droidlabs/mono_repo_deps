require 'benchmark'

class MonoRepoDeps::Package::Initializer
  include MonoRepoDeps::Mixins

  Inject = MonoRepoDeps::Deps[
    "package.dependency_bypasser",
    "package.repo"
  ]

  include Inject

  sig do
    params(
      package_name: T.any(Symbol, String),
      env: Symbol,
      imported: T::Array[Symbol]
    )
    .void
  end
  def call(package_name, env:, imported: [])
    package_name = package_name.to_sym
    packages_import_order = []

    time = Benchmark.realtime do
      packages_import_order = dependency_bypasser
        .call(package_name: package_name, env: env, imported: imported)
        .map { repo.find(_1) }
        .each { MonoRepoDeps.current_project.loader.push_dir(_1.workdir_path) }
        .tap { MonoRepoDeps.current_project.loader.setup }
        .each { |package| require package.entrypoint_file if File.exist?(package.entrypoint_file) }
    end

    puts "imported package '#{package_name}' with #{packages_import_order.size} dependencies in #{'%.2f' % time} seconds for env: #{env}"

    nil
  end
end
