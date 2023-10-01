class MonoRepoDeps::Package
  include MonoRepoDeps::Mixins

  attr_reader :name, :root_path, :dependencies, :configs

  DEFAULT_ENV = :_default_

  Contract String, String, String => nil
  def initialize(root_path, package_dir)
    @current_env = DEFAULT_ENV
    @dependencies = { @current_env => [] }
    @root_path = root_path
    @package_dir = package_dir

    nil
  end

  def get_dependencies(env = nil)
    result = @dependencies[DEFAULT_ENV]
    result += @dependencies.fetch(env, []) unless env.nil?

    result
  end

  Contract Maybe[Or[String, Symbol]] => Symbol
  def name(name = nil)
    name.nil? ? @name : @name = name.to_sym
  end

  def workdir_path
    File.join( self.root_path, @package_dir )
  end

  def entrypoint_file
    File.join( self.workdir_path, "#{name}.rb" )
  end

  # Contract Symbol, Proc => nil
  def dependency(env = DEFAULT_ENV, &block)
    @current_env = env
    instance_eval(&block)
    @current_env = DEFAULT_ENV

    nil
  end

  def import_config(config_name)
    # TODO: implement me
  end

  Contract Or[Symbol, String], KeywordArgs[
    skip: Maybe[ArrayOf[Or[Symbol, String]]],
    only: Maybe[ArrayOf[Or[Symbol, String]]],
  ] => nil
  def import(package_name, skip: nil, only: nil)
    package_name = package_name.to_sym
    skip = skip&.map(&:to_sym)
    only = only&.map(&:to_sym)

    @dependencies[@current_env] ||= []

    already_imported = @dependencies[@current_env].detect do
      _1[:name] == package_name
    end

    # TODO: use logger
    puts ("duplicated import '#{package_name}' was already added for package '#{name}'") if already_imported

    @dependencies[@current_env] << {
      name: package_name,
      skip: skip,
      only: only
    }

    nil
  end

  Contract Proc => nil
  def package(&block)
    instance_exec(&block)

    nil
  end

  Contract String => nil
  def version(value)
    # TODO: REMOVE DEPRECATED
  end
end