RSpec.describe MonoRepoDeps::Package::DependencyBypasser do
  before(:each) do
    MonoRepoDeps::Container.stub("package.list", packages_list)

    MonoRepoDeps.current_project = MonoRepoDeps::Project.new(
      root_path: 'some/path',
      env: :test
    )
  end

  context "reject dependencies listed in :skip option" do
    let(:packages_list) {
      Proc.new do
        [
          SpecHelper.build_package(name: :package_1, deps: [{name: :package_2, only: []}]),
          SpecHelper.build_package(name: :package_2, deps: [{name: :package_3}]),
          SpecHelper.build_package(name: :package_3, deps: []),
        ]
      end
    }

    it {
      expect(
        subject.call( package_name: :package_1, env: :production )
      ).to match([:package_2, :package_1])
    }
  end

  context "put dependencies in a proper order" do
    let(:packages_list) {
      Proc.new do
        [
          SpecHelper.build_package(name: :package_1, deps: [{name: :package_4}, {name: :package_2}, {name: :package_3}]),
          SpecHelper.build_package(name: :package_2, deps: [{name: :package_3}, {name: :package_4}]),
          SpecHelper.build_package(name: :package_3, deps: [{name: :package_4}]),
          SpecHelper.build_package(name: :package_4, deps: []),
        ]
      end
    }

    it {
      expect(
        subject.call( package_name: :package_1, env: :production )
      ).to match([:package_4, :package_3, :package_2, :package_1])
    }
  end
end
