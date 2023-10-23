class MonoRepoDeps::Project
  include MonoRepoDeps::Mixins

  attr_reader :env, :configs_dir, :package_dirname, :root_path, :packages, :loader, :tasks, :packages_lookup_subdir

  DEFAULT_OPTIONS = {
    configs_dir: 'configs',
    package_dirname: 'package',
    packages_lookup_subdir: ".",
    loader: MonoRepoDeps::Loaders::Base.new,
    tasks: []
  }

  Contract KeywordArgs[
    root_path: String,
    env: Symbol,
    loader: Maybe[MonoRepoDeps::Loaders::Base],
    configs_dir: Maybe[String],
    package_dirname: Maybe[String],
    packages_lookup_subdir: Maybe[String],
    tasks: Maybe[ArrayOf[MonoRepoDeps::Task]]
  ] => nil
  def initialize(root_path:, env:, loader: nil, configs_dir: nil, package_dirname: nil, packages_lookup_subdir: nil, tasks: nil)
    @root_path = root_path
    @env = env
    @packages = []

    @loader = loader || DEFAULT_OPTIONS.fetch(:loader)
    @tasks = tasks || DEFAULT_OPTIONS.fetch(:tasks)
    @configs_dir = configs_dir || DEFAULT_OPTIONS.fetch(:configs_dir)
    @package_dirname = package_dirname || DEFAULT_OPTIONS.fetch(:package_dirname)
    @packages_lookup_subdir = packages_lookup_subdir || DEFAULT_OPTIONS.fetch(:packages_lookup_subdir)

    nil
  end

  def set_packages(packages)
    @packages = packages
  end
end
