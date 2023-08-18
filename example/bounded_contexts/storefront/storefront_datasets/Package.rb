package do
  name 'storefront_datasets'
end

dependency do
  import 'db_connection'
end

dependency :test do
  import 'test_utils'
end