RSpec.describe MonoRepoDeps::Package::Builder do
  let(:package_root) { File.join(SpecHelper.examples_dir, "bounded_contexts/orders/orders_app") }
  let(:package_dirname) { 'package' }

  it "works" do
    package = subject.call(package_root, SpecHelper.examples_dir, package_dirname)

    expect(package).to be_a(MonoRepoDeps::Package)
    expect(package.root_path).to eq(package_root)
    expect(package.name).to eq(:orders_app)

    expect(package.dependencies).to eq({
      _default_: [:orders_core],
      test: [:test_utils, :storefront_core]
    })
  end
end
