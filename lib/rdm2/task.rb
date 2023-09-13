class Rdm2::Task
  include Rdm2::Mixins

  attr_reader :name, :on, :block

  Contract KeywordArgs[
    name: Symbol,
    on: Symbol,
    block: Proc
  ] => nil
  def initialize(name:, on:, block:)
    @name = name.to_sym
    @on = on
    @block = block

    nil
  end
end