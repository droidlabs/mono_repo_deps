RSpec.describe Rdm2::Package::Importer do
  it "works" do
    expect(Object.const_defined?(:OrdersApp)).to be false

    Rdm2.for_current_project(examples_dir) do
      Rdm2::Container["package.importer"].call('orders_app', env: :test)
    end

    expect(Object.const_defined?(:OrdersApp)).to be true
  end
end