require 'contracts'

module Rdm2::Mixins
  # class Container
  #   extend Dry::Container::Mixin
  # end

  # Import = Dry::AutoInject(Container)

  def self.included(base)
    base.include Contracts::Core
    base.include Contracts::Builtin

    # base.define_singleton_method :register do |key|
    #   Container.register key, self.new
    # end

    # base.define_singleton_method :import do |dependency, as: nil|
    #   dependencies = as.nil? ? [dependency] : [as => dependency]

    #   include Import[*dependencies]
    # end
  end
end