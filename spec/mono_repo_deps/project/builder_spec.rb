RSpec.describe MonoRepoDeps::Project::Builder do
  it "works" do
    project = MonoRepoDeps::Container["project.builder"].call(
      File.join(examples_dir, "bounded_contexts/orders/orders_app")
    )

    expect(project).to be_a(MonoRepoDeps::Project)
    expect(project.root_path).to eq(examples_dir)
    expect(project.packages.first).to be_a(MonoRepoDeps::Package)
    expect(project.loader).to be_a(MonoRepoDeps::Loaders::Zeitwerk)
  end
end