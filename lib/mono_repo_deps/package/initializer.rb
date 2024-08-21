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
    )
    .void
  end
  def call(package_name, env:)
    package = repo.find!(package_name.to_sym)
    sorted_packages = nil

    time = Benchmark.realtime do
      sorted_packages = dependency_bypasser
        .call(package_name: package.name, env: env)
        .map { |name| repo.find(name) }

      sorted_packages.each do |sorted_package|
        MonoRepoDeps.current_project.loader.push_dir(sorted_package.workdir_path)
        MonoRepoDeps.current_project.loader.loader.do_not_eager_load(sorted_package.workdir_path)
      end

      MonoRepoDeps.current_project.loader.setup

      sorted_packages.each do |package|
        require package.entrypoint_file if File.exist?(package.entrypoint_file)
      end
    end

    puts "imported package '#{package_name}' with #{sorted_packages.size} dependencies in #{'%.2f' % time} seconds for env: #{env}"

    nil
  end
end
