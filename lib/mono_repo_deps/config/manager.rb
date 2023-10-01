class MonoRepoDeps::Config::Manager
  include MonoRepoDeps::Mixins

  include MonoRepoDeps::Deps[
    config_loader: "config.loader"
  ]

  Contract Symbol, Maybe[ArrayOf[Any]] => MonoRepoDeps::Config
  def method_missing(method_name, *args)
    config_loader.call(method_name, *args)
  end
end