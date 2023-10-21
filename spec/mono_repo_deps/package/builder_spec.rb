RSpec.describe MonoRepoDeps::Package::Builder do
  let(:package_root) { File.join(examples_dir, "bounded_contexts/orders/orders_app") }
  let(:package_dirname) { 'package' }

  it "works" do
    package = MonoRepoDeps::Container["package.builder"].call(package_root, examples_dir, package_dirname)

    expect(package).to be_a(MonoRepoDeps::Package)
    expect(package.root_path).to eq(package_root)
    expect(package.name).to eq(:orders_app)
  end
end
