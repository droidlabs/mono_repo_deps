class MonoRepoDeps::Project::Factory
  include MonoRepoDeps::Mixins

  # TODO: This mapping should be in a separate service. Also we should allow extending this variable.
  LOADERS_MAPPING = { :zeitwerk => MonoRepoDeps::Loaders::Zeitwerk }

  Contract String, Proc => MonoRepoDeps::Project
  def call(project_root, &setup_content)
    @project = MonoRepoDeps::Project.new(project_root)

    instance_exec(&setup_content)

    @project
  end

  private

  Contract Proc => nil
  def setup(&block)
    instance_exec(@project, &block)

    nil
  end

  Contract Maybe[Or[String, Symbol, Proc]] => Symbol
  def set_env(value = nil)
    if value.nil? && !block_given?
      raise StandardError.new("block or value should be provided")
    end

    @project.instance_exec do
      @env = (value.is_a?(Proc) ? value.call : value).to_sym
    end
  end

  Contract String => nil
  def set_configs_dir(value)
    @project.instance_exec do
      @configs_dir = value
    end

    nil
  end

  Contract String => nil
  def set_package_dirname(value)
    @project.instance_exec do
      @package_dirname = value
    end

    nil
  end

  Contract Symbol, Proc => nil
  def set_loader(name, &block)
    @project.instance_exec do
      @loader = LOADERS_MAPPING.fetch(name).new(self, &block)
    end

    nil
  end

  Contract String => nil
  def set_packages_lookup_subdir(value)
    @project.instance_exec do
      @packages_lookup_subdir = value
    end

    nil
  end

  Contract Symbol, KeywordArgs[
    on: Symbol
  ], Proc => nil
  def register_task(name, on:, &block)
    @project.instance_exec do
      @tasks.push(
        MonoRepoDeps::Task.new(
          name: name,
          on: on,
          block: block
        )
      )
    end

    nil
  end
end
