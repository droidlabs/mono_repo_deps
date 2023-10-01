require 'yaml'
require 'erb'
require 'ostruct'

class MonoRepoDeps::Config::Loader
  include MonoRepoDeps::Mixins

  DEFAULT_CONFIG_FILENAME = 'default.yml'

  Contract Or[String, Symbol] => MonoRepoDeps::Config
  def call(config_name)
    config_name = config_name.to_s
    config = MonoRepoDeps::Config.new

    default_config_filename = File.join(
      MonoRepoDeps.current_project.root_path,
      MonoRepoDeps.current_project.configs_dir,
      config_name,
      DEFAULT_CONFIG_FILENAME
    )

    unless File.exists?(default_config_filename)
      raise StandardError.new("Config '#{config_name}' was not found. Add it to '#{default_config_filename}'")
    end

    hash =
      begin
        YAML.load( ERB.new(File.read(default_config_filename)).result )
      rescue => e
        puts ERB.new(File.read(default_config_filename)).result.inspect
      end

    hash_to_config(
      hash: hash,
      config: config
    )

    env_config_filename = File.join(
      MonoRepoDeps.current_project.root_path,
      MonoRepoDeps.current_project.configs_dir,
      config_name,
      "#{MonoRepoDeps.current_project.env}.yml"
    )

    hash_to_config(
      hash: YAML.load( ERB.new(File.read(env_config_filename)).result ),
      config: config
    ) if File.exists?(env_config_filename)

    config.send(config_name)
  end

  private

  def hash_to_config(hash:, config:)
    hash.each do |key, value|
      if value.is_a?(Hash)
        nested_config = config.read_attribute(key)
        if nested_config.nil? || !nested_config.is_a?(MonoRepoDeps::Config)
          nested_config = MonoRepoDeps::Config.new
        end
        hash_to_config(hash: value, config: nested_config)
        config.write_attribute(key, nested_config)
      else
        config.write_attribute(key, value)
      end
    end
  end
end