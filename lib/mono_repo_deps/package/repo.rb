class MonoRepoDeps::Package::Repo
  include MonoRepoDeps::Mixins

  include MonoRepoDeps::Deps[
    "package.list",
  ]

  Contract nil => ArrayOf[MonoRepoDeps::Package]
  def all
    list.call
  end

  Contract KeywordArgs[
    name: Maybe[ Or[ ArrayOf[Symbol], Symbol ] ]
  ] => ArrayOf[MonoRepoDeps::Package]
  def filter(name: nil)
    packages = all

    unless name.nil?
      names = name.is_a?(Array) ? name : [name]
      names = names.map(&:to_sym)

      packages = packages.select { names.include?(_1.name) }
    end

    packages
  end

  Contract Or[Symbol, String] => Maybe[MonoRepoDeps::Package]
  def find(package_name)
    all.detect { _1.name == package_name.to_sym }
  end

  Contract Or[Symbol, String] => MonoRepoDeps::Package
  def find!(package_name)
    find(package_name) || (raise StandardError.new("package '#{package_name}' was not found for MonoRepoDeps project '#{MonoRepoDeps.current_project.root_path}'"))
  end
end
