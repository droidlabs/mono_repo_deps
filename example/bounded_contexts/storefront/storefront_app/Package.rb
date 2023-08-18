package do
  name 'storefront_app'
end

dependency do
  import 'storefront_core'
end

dependency :test do
  import 'test_utils'
end