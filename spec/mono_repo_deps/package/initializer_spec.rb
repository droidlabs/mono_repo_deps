RSpec.describe MonoRepoDeps::Package::Initializer do
  it "imports dependent packages" do
    expect(Object.const_defined?(:OrdersApp)).to be false

    MonoRepoDeps.sync_current_project!(SpecHelper.examples_dir) do
      subject.call('orders_app', env: :test, prevent_eager_load: true)
    end

    expect(Object.const_defined?(:OrdersApp)).to be true
  end
end
