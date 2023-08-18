package do
  name 'storefront_core'
end

dependency do
  import 'storefront_datasets'
end

dependency :test do
  import 'test_utils'
end