require 'zeitwerk'
require 'benchmark'

class MonoRepoDeps::Loaders::Zeitwerk < MonoRepoDeps::Loaders::Base
  include MonoRepoDeps::Mixins

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
    time = Benchmark.realtime do
      @loader.eager_load
    end

    puts "eager_load dependencies in #{'%.2f' % time} seconds"
  end

  def check_classes
    check_classes_loader = @loader.dup
    check_classes_loader.on_load { |cpath, value, abspath| puts value }

    errors = []

    begin
      check_classes_loader.eager_load
    rescue Zeitwerk::NameError => e
      match = e.message.match(ERROR_MESSAGE_REGEX)

      raise e if match.nil?

      # TODO: use logger
      errors << "#{match[:path]} => #{match[:klass]}"
      check_classes_loader.ignore(match[:path])
      retry
    end

    puts errors
    raise StandardError.new("loader fails with #{errors.count} errors") if errors.any?

    nil
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