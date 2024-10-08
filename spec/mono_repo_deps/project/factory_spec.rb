RSpec.describe MonoRepoDeps::Project::Factory do
  let(:block) {
    Proc.new do
      setup do |project|
        set_env ->() { :test }

        set_configs_dir 'configs'
        set_package_dirname 'package'

        set_loader :zeitwerk do
          inflect 'uuid_generator' => "UUIDGenerator"
          overwrite ->(klass_name) { klass_name.gsub(/Api/) { _1.upcase } }
          ignore "\#{project}**/schema_migrations"
        end
      end
    end
  }

  it "sets up project" do
    project = subject.call('example_dir', init_proc: block)

    expect(project.env).to eq(:test)
    expect(project.configs_dir).to eq('configs')
    expect(project.package_dirname).to eq('package')
    expect(project.loader).to be_a(MonoRepoDeps::Loaders::Zeitwerk)
  end
end
