package do
  name 'orders_app'
end

dependency do
  import 'orders_core'
end

dependency :test do
  import 'test_utils'
  import 'storefront_core'
end