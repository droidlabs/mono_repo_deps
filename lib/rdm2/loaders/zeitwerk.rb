require 'zeitwerk'

class Rdm2::Loaders::Zeitwerk < Rdm2::Loaders::Base
  include Rdm2::Mixins

  ERROR_MESSAGE_REGEX = /expected file (?<path>[\w\/]+.rb) to define constant (?<klass>[\w:]+)/

  def initialize(...)
    @loader = Zeitwerk::Loader.new
    @loader.inflector = Class.new(Zeitwerk::Inflector).new
    @loader.enable_reloading

    super(...)
  end

  def setup
    apply_rules_for(@loader)
    @loader.setup
  end

  def eager_load
    @loader.eager_load
  end

  def check_classes
    check_classes_loader = @loader.dup

    begin
      check_classes_loader.eager_load
    rescue Zeitwerk::NameError => e
      match = e.message.match(ERROR_MESSAGE_REGEX)

      raise e if match.nil?

      # TODO: use logger
      puts "#{match[:path]} => #{match[:klass]}"
      check_classes_loader.ignore(match[:path])
      retry
    end
  end

  def apply_rules_for(entity)
    @autoload_dirs.uniq.each { entity.push_dir(_1) }
    @ignore_dirs.uniq.each { entity.ignore(_1) }

    entity.inflector.inflect(@inflections)

    result_overwriter = ->(kname) { @overwriters.each { |o| kname = o.call(kname) }; kname }
    entity.inflector.define_singleton_method(:camelize) do |basename, abspath|
      result_overwriter.call( super(basename, abspath) )
    end
  end
end