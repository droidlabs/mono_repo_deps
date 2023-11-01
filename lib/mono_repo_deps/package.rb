class MonoRepoDeps::Package
  include MonoRepoDeps::Mixins

  attr_reader :name, :root_path, :dependencies, :configs

  DEFAULT_ENV = :_default_

  DependencyDto = Struct.new(:name, :only, :skip, keyword_init: true)

  sig do
    params(
      name: Symbol,
      root_path: String,
      package_dirname: String,
      dependencies: T::Hash[Symbol, DependencyDto]
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
    params(env: T.nilable(Symbol)).returns(T::Array[DependencyDto])
  end
  def get_dependencies(env = nil)
    [DEFAULT_ENV, env].uniq.compact.inject([]) do |acc, item|
      acc += @dependencies.fetch(item, [])
    end
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
end
