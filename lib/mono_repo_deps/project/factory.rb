class MonoRepoDeps::Project::Factory
  include MonoRepoDeps::Mixins

  Contract String, KeywordArgs[
    init_proc: Proc
  ] => MonoRepoDeps::Project
  def call(root_path, init_proc:)
    @tasks = []
    @root_path = root_path

    instance_exec(&init_proc)

    project = MonoRepoDeps::Project.new(
      root_path: root_path,
      env: @env,
      configs_dir: @configs_dir,
      package_dirname: @package_dirname,
      packages_lookup_subdir: @packages_lookup_subdir,
      loader: @loader,
      tasks: @tasks
    )
  end

  private

  Contract Proc => nil
  def setup(&block)
    instance_exec(@project, &block)

    nil
  end

  Contract Maybe[Or[String, Symbol, Proc]] => nil
  def set_env(value)
    @env = (value.is_a?(Proc) ? value.call : value).to_sym

    raise MonoRepoDeps::Error.new("block or value should be provided") if @env.nil?

    nil
  end

  Contract String => nil
  def set_configs_dir(value)
    @configs_dir = value

    nil
  end

  Contract String => nil
  def set_package_dirname(value)
    @package_dirname = value

    nil
  end

  Contract Symbol, Proc => nil
  def set_loader(name, &block)
    @loader = MonoRepoDeps::Loaders::Base.registry.fetch(name).new(@root_path, &block)

    nil
  end

  Contract String => nil
  def set_packages_lookup_subdir(value)
    @packages_lookup_subdir = value

    nil
  end

  Contract Symbol, KeywordArgs[
    on: Symbol
  ], Proc => nil
  def register_task(name, on:, &block)
    @tasks.push(
      MonoRepoDeps::Task.new(
        name: name,
        on: on,
        block: block
      )
    )

    nil
  end
end
