RSpec.describe Rdm2::Project::Builder do
  it "works" do
    project = Rdm2::Container["project.builder"].call(
      File.join(examples_dir, "bounded_contexts/orders/orders_app")
    )

    expect(project).to be_a(Rdm2::Project)
    expect(project.root_path).to eq(examples_dir)
    expect(project.packages.first).to be_a(Rdm2::Package)
    expect(project.loader).to be_a(Rdm2::Loaders::Zeitwerk)
  end
end