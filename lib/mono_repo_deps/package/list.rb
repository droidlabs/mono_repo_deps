class MonoRepoDeps::Package::List
  include MonoRepoDeps::Mixins

  sig do
    returns(T::Array[MonoRepoDeps::Package])
  end
  def call
    MonoRepoDeps.current_project.packages
  end
end
