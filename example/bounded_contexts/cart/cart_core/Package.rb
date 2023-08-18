package do
  name 'cart_core'
end

dependency do
  import 'cart_datasets'
  import 'orders_query_api', only: ['orders_datasets']
end

dependency :test do
  import 'test_utils'
end