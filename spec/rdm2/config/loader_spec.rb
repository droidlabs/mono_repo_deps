RSpec.describe Rdm2::Config::Loader do
  it "works" do
    Rdm2.for_current_project(examples_dir) do
      config = Rdm2::Container["config.loader"].call('orders_app')

      expect(config).to be_a(Rdm2::Config)
      expect(config.host).to eq('some_test_host')
      expect(config.port).to eq(1234)
      expect(config.db).to eq('some_db')
    end
  end
end