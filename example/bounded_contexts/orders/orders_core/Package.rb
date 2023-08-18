package do
  name 'orders_core'
end

dependency do
  import 'orders_datasets'
  import 'paypal_client'
end

dependency :test do
  import 'test_utils'
  import 'storefront_core'
end