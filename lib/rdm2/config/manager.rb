class Rdm2::Config::Manager
  include Rdm2::Mixins

  include Rdm2::Deps[
    config_loader: "config.loader"
  ]

  Contract Symbol, Maybe[ArrayOf[Any]] => Rdm2::Config
  def method_missing(method_name, *args)
    config_loader.call(method_name, *args)
  end
end