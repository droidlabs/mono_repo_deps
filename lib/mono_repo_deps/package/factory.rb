# frozen_string_literal: true
class MonoRepoDeps::Package::Factory
  include MonoRepoDeps::Mixins

  sig do
    params(
      package_root: String,
      package_dirname: String,
      init_proc: T.proc.params(args: T.anything).returns(T.anything)
    )
    .returns(MonoRepoDeps::Package)
  end
  def call(package_root, package_dirname, init_proc:)
    @dependencies = Hash.new { |h, k| h[k] = [] }
    @current_env = MonoRepoDeps::Package::DEFAULT_ENV

    instance_exec(&init_proc)

    package = MonoRepoDeps::Package.new(
      name: @name,
      root_path: package_root,
      package_dirname: package_dirname,
      dependencies: @dependencies
    ).tap { check_duplicate_dependencies(_1) }
  end

  private

  def check_duplicate_dependencies(package)
    package.get_dependency_envs.each do |env|
      already_imported = package
        .get_dependencies(env)
        .map(&:name)
        .group_by{ |e| e }
        .select { |k, v| v.size > 1 }
        .keys

      if already_imported.any?
        puts "WARNING: duplicated import for following packages #{already_imported.inspect} was already added for package '#{package.name}' for env '#{env}'"
      end
    end
  end

  sig do
    params(
      env: Symbol,
      block: T.proc.params(args: T.anything).returns(T.anything)
    )
    .void
  end
  def dependency(env = MonoRepoDeps::Package::DEFAULT_ENV, &block)
    @current_env = env
    instance_eval(&block)
    @current_env = MonoRepoDeps::Package::DEFAULT_ENV

    nil
  end

  sig do
    params(
      package_name: T.any(Symbol, String),
      skip: T.nilable(T::Array[Symbol]),
      only: T.nilable(T::Array[Symbol]),
    )
    .void
  end
  def import(package_name, skip: nil, only: nil)
    package_name = package_name.to_sym
    skip = skip&.map(&:to_sym)
    only = only&.map(&:to_sym)

    @dependencies[@current_env] << MonoRepoDeps::Package::DependencyDto.new(name: package_name, skip: skip, only: only)

    nil
  end

  sig do
    params(
      block: T.proc.params(args: T.anything).returns(T.anything)
    )
    .void
  end
  def package(&block)
    instance_exec(&block)

    nil
  end

  sig do
    params(
      value: T.any(String, Symbol)
    )
    .void
  end
  def name(value)
    @name = value.to_sym

    nil
  end
end
