RSpec.describe MonoRepoDeps::Config::Loader do
  it "works" do
    MonoRepoDeps.sync_current_project!(SpecHelper.examples_dir) do
      config = MonoRepoDeps::Container["config.loader"].call('orders_app')

      expect(config).to be_a(MonoRepoDeps::Config)
      expect(config.host).to eq('some_test_host')
      expect(config.port).to eq(1234)
      expect(config.db).to eq('some_db')
    end
  end
end
