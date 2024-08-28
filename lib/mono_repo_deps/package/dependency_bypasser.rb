require 'set'

class MonoRepoDeps::Package::DependencyBypasser
  include MonoRepoDeps::Mixins

  Inject = MonoRepoDeps::Deps[
    packages_repo: "package.repo"
  ]

  include Inject

  sig do
    params(
      package_name: Symbol,
      env: Symbol,
    )
    .returns(T::Array[Symbol])
  end
  def call(package_name:, env:)
    walk(package_name: package_name, env: env, imported: Set.new)
  end

  private

  def walk(package_name:, env:, imported:, packages_order: [])
    package = packages_repo.find!(package_name)

    return if !imported.add?(package_name)

    package_dependencies = package.get_dependencies(env)

    package_dependencies.each do |name|
      walk(
        package_name: name,
        imported: imported,
        packages_order: packages_order,
        env: env# MonoRepoDeps::Package::DEFAULT_ENV,
      )
    end

    packages_order.push(package_name)
  end
end
