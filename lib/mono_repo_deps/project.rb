class MonoRepoDeps::Project
  include MonoRepoDeps::Mixins

  attr_reader :configs_dir, :package_dirname, :root_path, :packages, :loader, :tasks, :packages_lookup_subdir

  Contract String => nil
  def initialize(root_path, &block)
    @env = nil
    @loader = nil
    @root_path = root_path
    @packages = []
    @tasks = []
    @packages_lookup_subdir = "."
    @configs_dir = 'configs'
    @package_dirname = 'package'

    nil
  end

  def env
    @env || (raise StandardError.new("current :env is not set"))
  end

  def set_packages(packages)
    @packages = packages
  end
end
