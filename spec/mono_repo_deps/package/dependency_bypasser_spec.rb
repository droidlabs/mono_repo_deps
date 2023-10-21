RSpec.describe MonoRepoDeps::Package::DependencyBypasser do
  let(:packages_list) {
    Proc.new do
      [
        MonoRepoDeps::Package.new(
          name: :package_1,
          root_path: 'test',
          package_dirname: 'package',
          dependencies: {
            MonoRepoDeps::Package::DEFAULT_ENV => [
              MonoRepoDeps::Package::DependencyDto.new(name: :package_2, only: []),
            ]
          }
        ),
        MonoRepoDeps::Package.new(
          name: :package_2,
          root_path: 'test',
          package_dirname: 'package',
          dependencies: {
            MonoRepoDeps::Package::DEFAULT_ENV => [
              MonoRepoDeps::Package::DependencyDto.new(name: :package_3),
            ]
          }
        ),
        MonoRepoDeps::Package.new(
          name: :package_3,
          root_path: 'test',
          package_dirname: 'package',
          dependencies: {
            MonoRepoDeps::Package::DEFAULT_ENV => []
          }
        )
      ]
    end
  }

  before(:each) do
    MonoRepoDeps.current_project = MonoRepoDeps::Container["project.factory"].call('some/path') do
      set_env :test
    end
  end


  it "reject dependencies listed in :skip option" do
    MonoRepoDeps::Container.stub("package.list", packages_list)

    expect(
      subject.call(
        package_name: :package_1,
        env: :production
      )
    ).to match([:package_2, :package_1])


    MonoRepoDeps::Container.unstub
  end
end



  # def expect_importing(package, imported_packages, entrypoints = [], only = nil)
  #   expect(subject).to receive(:import_dependency!).with(
  #     {name: package, only: only, skip: nil}, imported_packages, entrypoints, :test
  #   ).and_call_original
  #   (imported_packages + [package]).uniq
  # end

  # it "will #import dependencies in the right order" do
  #   imported_packages = []
  #   imported_packages = expect_importing(:orders_app, imported_packages)
  #   imported_packages = expect_importing(:orders_core, imported_packages)
  #   imported_packages = expect_importing(:orders_datasets, imported_packages)
  #   imported_packages = expect_importing(:db_connection, imported_packages)
  #   imported_packages = expect_importing(:test_utils, imported_packages)
  #   imported_packages = expect_importing(:paypal_client, imported_packages, [
  #     a_string_matching("test_utils.rb"),
  #     a_string_matching("db_connection.rb"),
  #     a_string_matching("orders_datasets.rb")
  #   ])
  #   imported_packages = expect_importing(:storefront_core, imported_packages, [
  #     a_string_matching("test_utils.rb"),
  #     a_string_matching("db_connection.rb"),
  #     a_string_matching("orders_datasets.rb"),
  #     a_string_matching("paypal_client.rb")
  #   ])
  #   imported_packages = expect_importing(:storefront_datasets, imported_packages, [
  #     a_string_matching("test_utils.rb"),
  #     a_string_matching("db_connection.rb"),
  #     a_string_matching("orders_datasets.rb"),
  #     a_string_matching("paypal_client.rb")
  #   ])
  #   subject.call('orders_app', env: :test)
  # end

  # it "will #import_all dependencies in the right order" do
  #   imported_packages = []
  #   imported_packages = expect_importing(:test_utils, imported_packages)
  #   imported_packages = expect_importing(:db_connection, imported_packages, [
  #     a_string_matching("test_utils.rb")
  #   ])
  #   imported_packages = expect_importing(:orders_datasets, imported_packages, [
  #     a_string_matching("test_utils.rb"),
  #     a_string_matching("db_connection.rb"),
  #   ])
  #   imported_packages = expect_importing(:paypal_client, imported_packages, [
  #     a_string_matching("test_utils.rb"),
  #     a_string_matching("db_connection.rb"),
  #     a_string_matching("orders_datasets.rb"),
  #   ])
  #   imported_packages = expect_importing(:orders_core, imported_packages, [
  #     a_string_matching("test_utils.rb"),
  #     a_string_matching("db_connection.rb"),
  #     a_string_matching("orders_datasets.rb"),
  #     a_string_matching("paypal_client.rb"),
  #   ])
  #   imported_packages = expect_importing(:storefront_core, imported_packages, [
  #     a_string_matching("test_utils.rb"),
  #     a_string_matching("db_connection.rb"),
  #     a_string_matching("orders_datasets.rb"),
  #     a_string_matching("paypal_client.rb"),
  #   ])
  #   imported_packages = expect_importing(:storefront_datasets, imported_packages, [
  #     a_string_matching("test_utils.rb"),
  #     a_string_matching("db_connection.rb"),
  #     a_string_matching("orders_datasets.rb"),
  #     a_string_matching("paypal_client.rb"),
  #   ])
  #   imported_packages = expect_importing(:cart_query_api, imported_packages, [
  #     a_string_matching("test_utils.rb"),
  #     a_string_matching("db_connection.rb"),
  #     a_string_matching("orders_datasets.rb"),
  #     a_string_matching("paypal_client.rb"),
  #     a_string_matching("storefront_datasets.rb"),
  #     a_string_matching("storefront_core.rb"),
  #     a_string_matching("orders_core.rb"),
  #   ])
  #   imported_packages = expect_importing(:orders_app, imported_packages, [
  #     a_string_matching("test_utils.rb"),
  #     a_string_matching("db_connection.rb"),
  #     a_string_matching("orders_datasets.rb"),
  #     a_string_matching("paypal_client.rb"),
  #     a_string_matching("storefront_datasets.rb"),
  #     a_string_matching("storefront_core.rb"),
  #     a_string_matching("orders_core.rb"),
  #     a_string_matching("cart_query_api.rb"),
  #   ])
  #   imported_packages = expect_importing(:cart_core, imported_packages, [
  #     a_string_matching("test_utils.rb"),
  #     a_string_matching("db_connection.rb"),
  #     a_string_matching("orders_datasets.rb"),
  #     a_string_matching("paypal_client.rb"),
  #     a_string_matching("storefront_datasets.rb"),
  #     a_string_matching("storefront_core.rb"),
  #     a_string_matching("orders_core.rb"),
  #     a_string_matching("cart_query_api.rb"),
  #     a_string_matching("orders_app.rb"),
  #   ])
  #   imported_packages = expect_importing(:cart_datasets, imported_packages, [
  #     a_string_matching("test_utils.rb"),
  #     a_string_matching("db_connection.rb"),
  #     a_string_matching("orders_datasets.rb"),
  #     a_string_matching("paypal_client.rb"),
  #     a_string_matching("storefront_datasets.rb"),
  #     a_string_matching("storefront_core.rb"),
  #     a_string_matching("orders_core.rb"),
  #     a_string_matching("cart_query_api.rb"),
  #     a_string_matching("orders_app.rb")
  #   ])
  #   imported_packages = expect_importing(:orders_query_api, imported_packages, [
  #     a_string_matching("test_utils.rb"),
  #     a_string_matching("db_connection.rb"),
  #     a_string_matching("orders_datasets.rb"),
  #     a_string_matching("paypal_client.rb"),
  #     a_string_matching("storefront_datasets.rb"),
  #     a_string_matching("storefront_core.rb"),
  #     a_string_matching("orders_core.rb"),
  #     a_string_matching("cart_query_api.rb"),
  #     a_string_matching("orders_app.rb"),
  #     a_string_matching("cart_datasets.rb")
  #   ], [:orders_datasets])

  #   subject.import_all
  # end
