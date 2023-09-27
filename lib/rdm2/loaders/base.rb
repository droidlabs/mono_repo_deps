class Rdm2::Loaders::Base
  include Rdm2::Mixins

  attr_reader :overwriters, :inflections, :ignore_dirs, :autoload_dirs, :loader

  def initialize(&block)
    @overwriters = []
    @inflections = {}
    @ignore_dirs = []
    @autoload_dirs = []

    instance_exec(&block) if block_given?
  end

  def push_dir(dir)
    @autoload_dirs.push(dir)
  end

  def setup
    raise StandardError.new('not implemented')
  end

  def reload
    raise StandardError.new('not implemented')
  end

  def eager_load
    raise StandardError.new('not implemented')
  end

  def check_classes
    raise StandardError.new('not implemented')
  end

  module SetupDsl
    def inflect(hash)
      @inflections.merge!(hash)
    end

    def overwrite(proc)
      overwriters.push(proc)
    end

    def ignore(glob)
      @ignore_dirs.push(glob)
    end
  end

  include SetupDsl
end