package do
  name 'cart_query_api'
end

dependency do
  import 'orders_core'
  import 'orders_datasets'
end

dependency :test do
  import 'test_utils'
  import 'storefront_core'
end