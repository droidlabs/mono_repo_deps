class MonoRepoDeps::Package::DependencyBypasser
  include MonoRepoDeps::Mixins

  include MonoRepoDeps::Deps[
    packages_repo: "package.repo"
  ]

  Contract KeywordArgs[
    package_name: Symbol,
    only: Maybe[ArrayOf[Symbol]],
    skip: Maybe[ArrayOf[Symbol]],
    imported: Optional[ArrayOf[Symbol]],
    packages_order: Optional[ArrayOf[Symbol]],
    env: Symbol
  ] => ArrayOf[Symbol]
  def call(package_name:, only: nil, skip: nil, imported: [], packages_order: [], env:)
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
