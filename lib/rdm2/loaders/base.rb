require 'zeitwerk'

class Rdm2::Loaders::Base
  include Rdm2::Mixins

  def initialize
  end

  def push_dir(dir)
    raise StandardError.new('not implemented')
  end

  def setup
    raise StandardError.new('not implemented')
  end

  def eager_load
    raise StandardError.new('not implemented')
  end

  def check_classes
    raise StandardError.new('not implemented')
  end
end