RSpec.describe Rdm2::Package::Builder do
  let(:package_root) { File.join(examples_dir, "bounded_contexts/orders/orders_app") }
  let(:package_dir) { 'package' }

  it "works" do
    package = Rdm2::Container["package.builder"].call(package_root, examples_dir, package_dir)

    expect(package).to be_a(Rdm2::Package)
    expect(package.root_path).to eq(package_root)
    expect(package.name).to eq(:orders_app)
  end
end