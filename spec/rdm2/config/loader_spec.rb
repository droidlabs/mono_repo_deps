RSpec.describe Rdm2::Config::Loader do
  it "works" do
    project = Rdm2::Container["project.builder"].call(examples_dir)
    config = Rdm2::Container["config.loader"].call('orders_app')

    expect(config).to be_a(Rdm2::Config)
    expect(config.host).to eq('some_test_host')
    expect(config.port).to eq(1234)
    expect(config.db).to eq('some_db')
  end
end