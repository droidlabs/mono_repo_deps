class MonoRepoDeps::Project::Factory
  include MonoRepoDeps::Mixins

  sig do
    params(
      root_path: String,
      init_proc: T.proc.params(args: T.anything).returns(T.anything)
    )
    .returns(MonoRepoDeps::Project)
  end
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

  sig do
    params(
      block: T.proc.params(args: T.anything).returns(T.anything)
    )
    .void
  end
  def setup(&block)
    instance_exec(@project, &block)

    nil
  end

  sig do
    params(
      value: T.any(Symbol, String, T.proc.returns(T.any(String, Symbol)))
    )
    .void
  end
  def set_env(value)
    @env = (value.is_a?(Proc) ? value.call : value).to_sym

    raise MonoRepoDeps::Error.new("block or value should be provided") if @env.nil?

    nil
  end

  sig do
    params(value: String).void
  end
  def set_configs_dir(value)
    @configs_dir = value

    nil
  end

  sig do
    params(value: String).void
  end
  def set_package_dirname(value)
    @package_dirname = value

    nil
  end

  sig do
    params(
      name: Symbol,
      block: T.proc.params(args: T.anything).returns(T.anything)
    )
    .void
  end
  def set_loader(name, &block)
    @loader = MonoRepoDeps::Loaders::Base.registry.fetch(name).new(@root_path, &block)

    nil
  end

  sig do
    params(value: String).void
  end
  def set_packages_lookup_subdir(value)
    @packages_lookup_subdir = value

    nil
  end

  sig do
    params(
      name: Symbol,
      on: Symbol,
      block: T.proc.params(args: T.anything).returns(T.anything),
    )
    .void
  end
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
