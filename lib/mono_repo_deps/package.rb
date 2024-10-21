class MonoRepoDeps::Package
  include MonoRepoDeps::Mixins

  attr_reader :name, :root_path, :dependencies, :configs

  DEFAULT_ENV = :_default_

  sig do
    params(
      name: Symbol,
      root_path: String,
      package_dirname: String,
      dependencies: T::Hash[Symbol, Symbol]
    )
    .void
  end
  def initialize(name:, root_path:, package_dirname:, dependencies:)
    @name = name
    @root_path = root_path
    @package_dirname = package_dirname
    @dependencies = dependencies

    nil
  end

  sig do
    params(env: T.nilable(Symbol)).returns(T::Array[Symbol])
  end
  def get_dependencies(env = nil)
    default_deps = @dependencies.fetch(DEFAULT_ENV, [])
    env_deps     = @dependencies.fetch(env, [])

    default_deps | env_deps
  end

  def get_dependency_envs
    @dependencies.keys
  end

  def workdir_path
    File.join( self.root_path, @package_dirname )
  end

  def entrypoint_file
    File.join( self.workdir_path, "#{name}.rb" )
  end

  def specs_path
    File.join( self.root_path, '/spec/' )
  end
end
