class MonoRepoDeps::Task
  include MonoRepoDeps::Mixins

  attr_reader :name, :on, :block

  sig do
    params(
      name: Symbol,
      on: Symbol,
      block: T.proc.params(args: T.anything).returns(T.anything),
    )
    .void
  end
  def initialize(name:, on:, block:)
    @name = name.to_sym
    @on = on
    @block = block

    nil
  end
end
