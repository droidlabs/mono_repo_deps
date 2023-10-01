RSpec.describe MonoRepoDeps::Package::Importer do
  it "works" do
    expect(Object.const_defined?(:OrdersApp)).to be false

    MonoRepoDeps.for_current_project(examples_dir) do
      MonoRepoDeps::Container["package.importer"].call('orders_app', env: :test)
    end

    expect(Object.const_defined?(:OrdersApp)).to be true
  end
end