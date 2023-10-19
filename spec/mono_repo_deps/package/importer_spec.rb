RSpec.describe MonoRepoDeps::Package::Importer do
  it "imports dependent packages" do
    expect(Object.const_defined?(:OrdersApp)).to be false

    MonoRepoDeps.sync_current_project!(examples_dir) do
      MonoRepoDeps::Container["package.importer"].call('orders_app', env: :test)
    end

    expect(Object.const_defined?(:OrdersApp)).to be true
  end

  def expect_importing(package, imported_packages, entrypoints = [], only = nil)
    expect(subject).to receive(:import_dependency!).with(
      {name: package, only: only, skip: nil}, imported_packages, entrypoints, :test
    ).and_call_original
    (imported_packages + [package]).uniq
  end

  it "will #import dependencies in the right order" do
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

  it "will #import_all dependencies in the right order" do
    imported_packages = []
    imported_packages = expect_importing(:test_utils, imported_packages)
    imported_packages = expect_importing(:db_connection, imported_packages, [
      a_string_matching("test_utils.rb")
    ])
    imported_packages = expect_importing(:orders_datasets, imported_packages, [
      a_string_matching("test_utils.rb"),
      a_string_matching("db_connection.rb"),
    ])
    imported_packages = expect_importing(:paypal_client, imported_packages, [
      a_string_matching("test_utils.rb"),
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
    ])
    imported_packages = expect_importing(:orders_core, imported_packages, [
      a_string_matching("test_utils.rb"),
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb"),
    ])
    imported_packages = expect_importing(:storefront_core, imported_packages, [
      a_string_matching("test_utils.rb"),
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb"),
    ])
    imported_packages = expect_importing(:storefront_datasets, imported_packages, [
      a_string_matching("test_utils.rb"),
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb"),
    ])
    imported_packages = expect_importing(:cart_query_api, imported_packages, [
      a_string_matching("test_utils.rb"),
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb"),
      a_string_matching("storefront_datasets.rb"),
      a_string_matching("storefront_core.rb"),
      a_string_matching("orders_core.rb"),
    ])
    imported_packages = expect_importing(:orders_app, imported_packages, [
      a_string_matching("test_utils.rb"),
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb"),
      a_string_matching("storefront_datasets.rb"),
      a_string_matching("storefront_core.rb"),
      a_string_matching("orders_core.rb"),
      a_string_matching("cart_query_api.rb"),
    ])
    imported_packages = expect_importing(:cart_core, imported_packages, [
      a_string_matching("test_utils.rb"),
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb"),
      a_string_matching("storefront_datasets.rb"),
      a_string_matching("storefront_core.rb"),
      a_string_matching("orders_core.rb"),
      a_string_matching("cart_query_api.rb"),
      a_string_matching("orders_app.rb"),
    ])
    imported_packages = expect_importing(:cart_datasets, imported_packages, [
      a_string_matching("test_utils.rb"),
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb"),
      a_string_matching("storefront_datasets.rb"),
      a_string_matching("storefront_core.rb"),
      a_string_matching("orders_core.rb"),
      a_string_matching("cart_query_api.rb"),
      a_string_matching("orders_app.rb")
    ])
    imported_packages = expect_importing(:orders_query_api, imported_packages, [
      a_string_matching("test_utils.rb"),
      a_string_matching("db_connection.rb"),
      a_string_matching("orders_datasets.rb"),
      a_string_matching("paypal_client.rb"),
      a_string_matching("storefront_datasets.rb"),
      a_string_matching("storefront_core.rb"),
      a_string_matching("orders_core.rb"),
      a_string_matching("cart_query_api.rb"),
      a_string_matching("orders_app.rb"),
      a_string_matching("cart_datasets.rb")
    ], [:orders_datasets])

    subject.import_all
  end
end
