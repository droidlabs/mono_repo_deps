RSpec.describe MonoRepoDeps::Package do
  let(:block) {
    Proc.new do
      package do
        name 'package_0'
        version '1.0.0'
      end

      dependency do
        import 'package_1'
        import 'package_2', only: [:package_2_1]
        import 'package_3', skip: [:package_3_1]
      end

      dependency :test do
        import 'package_4'
      end
    end
  }

  it "sets up project" do
    package = MonoRepoDeps::Package.new(".", "packages")
    package.instance_exec(&block)

    expect(package.name).to eq(:package_0)
    expect(package.dependencies).to match({
      _default_: [
        { name: :package_1, only: nil, skip: nil },
        { name: :package_2, only: [:package_2_1], skip: nil },
        { name: :package_3, only: nil, skip: [:package_3_1] }
      ],
      test: [
        { name: :package_4, only: nil, skip: nil }
      ]
    })
  end

  let(:block_with_duplicates) {
    Proc.new do
      dependency do
        import 'package_1'
        import 'package_1', only: [:package_2_1]
      end
    end
  }


  it "doesn't allow to duplicate dependencies" do
    package = MonoRepoDeps::Package.new(".", "packages")
    expect {
      package.setup(&block_with_duplicates)
    }.to raise_error(StandardError)
  end
end