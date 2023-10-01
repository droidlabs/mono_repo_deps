# frozen_string_literal: true

RSpec.describe MonoRepoDeps do
  it "has a version number" do
    expect(MonoRepoDeps::VERSION).not_to be nil
  end

  # context "#init" do
  #   let(:package_root) { File.join(examples_dir, "bounded_contexts/orders/core/orders/bin") }

  #   it "works" do
  #     MonoRepoDeps.init(package_root, :test)
  #   end
  # end

  context "#import_package" do
    it "works" do
      # MonoRepoDeps.import_package('orders_app', from: examples_dir, env: :test)
    end
  end
end
