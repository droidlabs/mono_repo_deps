RSpec.describe MonoRepoDeps::Project::Initializer do
  it "works" do
    project = MonoRepoDeps::Container["project.initializer"].call(
      File.join(SpecHelper.examples_dir, "bounded_contexts/orders/orders_app")
    )

    expect(project).to be_a(MonoRepoDeps::Project)
    expect(project.root_path).to eq(SpecHelper.examples_dir)
    expect(project.packages.first).to be_a(MonoRepoDeps::Package)
    expect(project.loader).to be_a(MonoRepoDeps::Loaders::Zeitwerk)
  end
end
