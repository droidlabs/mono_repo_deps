RSpec.describe Rdm2::Package::Importer do
  it "works" do
    expect(Object.const_defined?(:OrdersApp)).to be false

    package = Rdm2::Container["package.importer"].call('orders_app', from: examples_dir, env: :test)

    expect(Object.const_defined?(:OrdersApp)).to be true
  end
end