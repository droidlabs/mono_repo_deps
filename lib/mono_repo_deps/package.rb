class MonoRepoDeps::Package
  include MonoRepoDeps::Mixins

  attr_reader :name, :root_path, :dependencies, :configs

  DEFAULT_ENV = :_default_

  DependencyDto = Struct.new(:name, :only, :skip, keyword_init: true)

  Contract String, String => nil
  def initialize(root_path, package_dirname)
    @current_env = DEFAULT_ENV
    @dependencies = Hash.new { |h, k| h[k] = [] }
    @root_path = root_path
    @package_dirname = package_dirname

    nil
  end

  Contract Or[nil, Symbol] => ArrayOf[DependencyDto]
  def get_dependencies(env = nil)
    @dependencies[DEFAULT_ENV] + @dependencies.fetch(env, [])
  end

  Contract Maybe[Or[String, Symbol]] => Symbol
  def name(name = nil)
    name.nil? ? @name : @name = name.to_sym
  end

  def workdir_path
    File.join( self.root_path, @package_dirname )
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
    # TODO: REMOVE DEPRECATED
  end

  Contract Or[Symbol, String], KeywordArgs[
    skip: Maybe[ArrayOf[Or[Symbol, String]]],
    only: Maybe[ArrayOf[Or[Symbol, String]]],
  ] => nil
  def import(package_name, skip: nil, only: nil)
    package_name = package_name.to_sym
    skip = skip&.map(&:to_sym)
    only = only&.map(&:to_sym)

    already_imported = get_dependencies(@current_env).map(&:name).include?(package_name)
    puts ("WARNING: duplicated import '#{package_name}' was already added for package '#{name}'") if already_imported

    @dependencies[@current_env] << DependencyDto.new(name: package_name, skip: skip, only: only)

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
