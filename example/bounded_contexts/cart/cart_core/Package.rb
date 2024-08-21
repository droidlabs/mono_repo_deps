package do
  name 'cart_core'
end

dependency do
  import 'cart_datasets'
  import 'orders_query_api'
end

dependency :test do
  import 'test_utils'
end
