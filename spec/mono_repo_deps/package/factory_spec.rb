RSpec.describe MonoRepoDeps::Package::Factory do
  let(:block) {
    Proc.new do
      package do
        name 'package_0'
      end

      dependency do
        import 'package_1'
        import 'package_2'
        import 'package_3'
      end

      dependency :test do
        import 'package_4'
      end
    end
  }

  it "sets up project" do
    package = subject.call('example_dir', 'package', init_proc: block)

    expect(package.name).to eq(:package_0)
    expect(package.dependencies).to match({
      _default_: [
        :package_1,
        :package_2,
        :package_3
      ],
      test: [
        :package_4
      ]
    })
  end
end
