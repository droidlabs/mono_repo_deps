RSpec.describe MonoRepoDeps::Package::Importer do
  it "imports dependent packages" do
    expect(Object.const_defined?(:OrdersApp)).to be false

    MonoRepoDeps.for_current_project(examples_dir) do
      subject.call('orders_app', env: :test)
    end

    expect(Object.const_defined?(:OrdersApp)).to be true
  end

  def expect_importing(package, imported_packages, entrypoints = [])
    expect(subject).to receive(:import_dependency!).with(
      {name: package, only: nil, skip: nil}, imported_packages, entrypoints, :test 
    ).and_call_original
    (imported_packages + [package]).uniq
  end

  xit "will import dependencies in the right order" do
    imported_packages = []
    imported_packages = expect_importing(:orders_app, imported_packages)
    imported_packages = expect_importing(:orders_core, imported_packages)
    imported_packages = expect_importing(:orders_datasets, imported_packages)
    imported_packages = expect_importing(:db_connection, imported_packages)
    imported_packages = expect_importing(:test_utils, imported_packages)
    imported_packages = expect_importing(:test_utils, imported_packages, [
      a_string_matching("test_utils.rb"), 
      a_string_matching("db_connection.rb")
    ])
    imported_packages = expect_importing(:paypal_client, imported_packages, [
      a_string_matching("test_utils.rb"), 
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb")
    ])
    imported_packages = expect_importing(:test_utils, imported_packages, [
      a_string_matching("test_utils.rb"), 
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb")
    ])
    imported_packages = expect_importing(:storefront_core, imported_packages, [
      a_string_matching("test_utils.rb"), 
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb")
    ])
    imported_packages = expect_importing(:storefront_datasets, imported_packages, [
      a_string_matching("test_utils.rb"), 
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb")
    ])
    imported_packages = expect_importing(:db_connection, imported_packages, [
      a_string_matching("test_utils.rb"), 
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb")
    ])
    imported_packages = expect_importing(:test_utils, imported_packages, [
      a_string_matching("test_utils.rb"), 
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb")
    ])
    imported_packages = expect_importing(:test_utils, imported_packages, [
      a_string_matching("test_utils.rb"), 
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb"),
      a_string_matching("storefront_datasets.rb")
    ])
    imported_packages = expect_importing(:test_utils, imported_packages, [
      a_string_matching("test_utils.rb"), 
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb"),
      a_string_matching("storefront_datasets.rb"),
      a_string_matching("storefront_core.rb"),
      a_string_matching("orders_core.rb")
    ])
    imported_packages = expect_importing(:storefront_core, imported_packages, [
      a_string_matching("test_utils.rb"), 
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb"),
      a_string_matching("storefront_datasets.rb"),
      a_string_matching("storefront_core.rb"),
      a_string_matching("orders_core.rb")
    ])
    subject.call('orders_app', env: :test)
  end

  it "will import dependencies in the right order" do
    imported_packages = []
    imported_packages = expect_importing(:orders_app, imported_packages)
    imported_packages = expect_importing(:orders_core, imported_packages)
    imported_packages = expect_importing(:orders_datasets, imported_packages)
    imported_packages = expect_importing(:db_connection, imported_packages)
    imported_packages = expect_importing(:test_utils, imported_packages)
    imported_packages = expect_importing(:paypal_client, imported_packages, [
      a_string_matching("test_utils.rb"), 
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb")
    ])
    imported_packages = expect_importing(:storefront_core, imported_packages, [
      a_string_matching("test_utils.rb"), 
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb")
    ])
    imported_packages = expect_importing(:storefront_datasets, imported_packages, [
      a_string_matching("test_utils.rb"), 
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb")
    ])
    subject.call('orders_app', env: :test)
  end
end