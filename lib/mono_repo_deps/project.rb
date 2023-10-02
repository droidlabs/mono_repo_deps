class MonoRepoDeps::Project
  include MonoRepoDeps::Mixins

  attr_reader :configs_dir, :package_dir, :root_path, :packages, :loader, :tasks, :packages_folder

  LOADERS_MAPPING = { :zeitwerk => MonoRepoDeps::Loaders::Zeitwerk }

  Contract String => nil
  def initialize(root_path, &block)
    @env = nil
    @loader = nil
    @root_path = root_path
    @packages = []
    @tasks = []
    @packages_folder = "."
    @configs_dir = 'configs'
    @package_dir = 'package'

    nil
  end

  def env
    @env || (raise StandardError.new("current :env is not set"))
  end

  Contract Proc => nil
  def setup(&block)
    instance_exec(self, &block)

    nil
  end

  Contract Maybe[Or[String, Symbol, Proc]] => Symbol
  def set_env(value = nil)
    if value.nil? && !block_given?
      raise StandardError.new("block or value should be provided")
    end

    @env = value.is_a?(Proc) ? value.call : value
    @env = @env.to_sym
  end

  def set_packages(packages)
    @packages = packages
  end

  Contract String => nil
  def set_configs_dir(value)
    @configs_dir = value

    nil
  end

  Contract String => nil
  def set_package_dir(value)
    @package_dir = value

    nil
  end

  Contract String => nil
  def set_packages_folder(value)
    @packages_folder = value

    nil
  end

  Contract Symbol, Proc => nil
  def set_loader(name, &block)
    @loader = LOADERS_MAPPING.fetch(name).new(&block)

    nil
  end

  def register_task(name, on:, &block)
    @tasks.push(
      MonoRepoDeps::Task.new(
        name: name,
        on: on,
        block: block
      )
    )
  end
end