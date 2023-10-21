RSpec.describe MonoRepoDeps::Package::Initializer do
  it "imports dependent packages" do
    expect(Object.const_defined?(:OrdersApp)).to be false

    MonoRepoDeps.sync_current_project!(examples_dir) do
      subject.call('orders_app', env: :test)
    end

    expect(Object.const_defined?(:OrdersApp)).to be true
  end
end
