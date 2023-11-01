class MonoRepoDeps::Config::Manager
  include MonoRepoDeps::Mixins

  Inject = MonoRepoDeps::Deps[
    config_loader: "config.loader"
  ]

  include Inject

  sig do
    params(
      method_name: Symbol,
      args: T.anything
    )
    .returns(MonoRepoDeps::Config)
  end
  def method_missing(method_name, *args)
    config_loader.call(method_name)
  end
end
