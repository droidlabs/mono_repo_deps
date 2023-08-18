package do
  name 'cart_app'
end

dependency do
  import 'cart_core'
end

dependency :test do
  import 'test_utils'
end