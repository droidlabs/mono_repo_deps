class MonoRepoDeps::Package::List
  include MonoRepoDeps::Mixins

  Contract nil => ArrayOf[MonoRepoDeps::Package]
  def call
    MonoRepoDeps.current_project.packages
  end
end
