require 'zeitwerk'

class Rdm2::Loaders::Zeitwerk < Rdm2::Loaders::Base
  include Rdm2::Mixins

  attr_accessor :overwriters

  ERROR_MESSAGE_REGEX = /expected file (?<path>[\w\/]+.rb) to define constant (?<klass>[\w:]+)/

  def initialize(&block)
    @loader = Zeitwerk::Loader.new
    @loader.inflector = Class.new(Zeitwerk::Inflector).new
    @overwriters = []

    instance_eval(&block)
  end

  def push_dir(dir)
    @loader.push_dir(dir)
  end

  def setup
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

  module SetupDsl
    def inflect(hash)
      @loader.inflector.inflect(hash)
    end

    def overwrite(proc)
      overwriters.push(proc)

      super_proc = ->(kname) {
        overwriters.each { |o| kname = o.call(kname) }; kname
      }

      @loader.inflector.define_singleton_method(:camelize) do |basename, abspath|
        super_proc.call( super(basename, abspath) )
      end
    end

    def ignore(glob)
      @loader.ignore(glob)
    end
  end

  include SetupDsl
end