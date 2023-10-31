class MonoRepoDeps::Package::Repo
  include MonoRepoDeps::Mixins

  Inject = MonoRepoDeps::Deps[
    "package.list",
  ]

  include Inject

  sig do
    returns(T::Array[MonoRepoDeps::Package])
  end
  def all
    list.call
  end

  sig do
    params(
      name: T.nilable(T.any(String, Symbol)),
    )
    .returns(T::Array[MonoRepoDeps::Package])
  end
  def filter(name: nil)
    packages = all

    unless name.nil?
      names = name.is_a?(Array) ? name : [name]
      names = names.map(&:to_sym)

      packages = packages.select { names.include?(_1.name) }
    end

    packages
  end

  sig do
    params(
      package_name: T.nilable(T.any(String, Symbol)),
    )
    .returns(T.nilable(MonoRepoDeps::Package))
  end
  def find(package_name)
    all.detect { _1.name == package_name.to_sym }
  end

  sig do
    params(
      package_name: T.nilable(T.any(String, Symbol)),
    )
    .returns(MonoRepoDeps::Package)
  end
  def find!(package_name)
    find(package_name) || (raise StandardError.new("package '#{package_name}' was not found for MonoRepoDeps project '#{MonoRepoDeps.current_project.root_path}'"))
  end
end
