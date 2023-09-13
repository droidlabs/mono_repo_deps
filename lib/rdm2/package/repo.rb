class Rdm2::Package::Repo
  include Rdm2::Mixins

  Contract nil => ArrayOf[Rdm2::Package]
  def all
    Rdm2.current_project.packages
  end

  Contract KeywordArgs[
    name: Maybe[ Or[ ArrayOf[Symbol], Symbol ] ]
  ] => ArrayOf[Rdm2::Package]
  def filter(name: nil)
    packages = all

    unless name.nil?
      names = name.is_a?(Array) ? name : [name]
      names = names.map(&:to_sym)

      packages = packages.select { names.include?(_1.name) }
    end

    packages
  end

  Contract Or[Symbol, String] => Maybe[Rdm2::Package]
  def find(package_name)
    all.detect { _1.name == package_name.to_sym }
  end

  Contract Or[Symbol, String] => Rdm2::Package
  def find!(package_name)
    find(package_name) || (raise StandardError.new("package '#{package_name}' was not found for Rdm2 project '#{Rdm2.current_project.root_path}'"))
  end
end