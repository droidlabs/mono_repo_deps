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
      only: T.nilable(T::Array[Symbol]),
      skip: T.nilable(T::Array[Symbol]),
      imported: T::Array[Symbol],
      packages_order: T::Array[Symbol],
    )
    .returns(T::Array[Symbol])
  end
  def call(package_name:, env:, only: nil, skip: nil, imported: [], packages_order: [])
    package = packages_repo.find!(package_name)

    return [] if imported.include?(package_name)
    imported.push(package.name)

    package_dependencies = package.get_dependencies(env)
    package_dependencies = package_dependencies.select { only.include?(_1.name) } unless only.nil?
    package_dependencies = package_dependencies.reject { skip.include?(_1.name) } unless skip.nil?

    package_dependencies.each do |dependency_dto|
      self.call(
        package_name: dependency_dto.name,
        skip: dependency_dto.skip,
        only: dependency_dto.only,
        imported: imported,
        packages_order: packages_order,
        env: env
      )
    end

    packages_order.push(package_name)
  end
end
