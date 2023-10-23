# frozen_string_literal: true
class MonoRepoDeps::Package::Factory
  include MonoRepoDeps::Mixins

  Contract String, String, KeywordArgs[
    init_proc: Proc
  ] => MonoRepoDeps::Package
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

  # Contract Symbol, Proc => nil
  def dependency(env = MonoRepoDeps::Package::DEFAULT_ENV, &block)
    @current_env = env
    instance_eval(&block)
    @current_env = MonoRepoDeps::Package::DEFAULT_ENV

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

    @dependencies[@current_env] << MonoRepoDeps::Package::DependencyDto.new(name: package_name, skip: skip, only: only)

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

  Contract Or[String, Symbol] => nil
  def name(value)
    @name = value.to_sym

    nil
  end
end
