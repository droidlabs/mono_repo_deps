# frozen_string_literal: true

ENV['RUBY_ENV'] = 'test'

require 'mono_repo_deps'
require 'dry/system/stubs'
require 'pry'

RSpec.configure do |config|
  MonoRepoDeps::Container.enable_stubs!

  config.after :each do
    MonoRepoDeps::Container.unstub
  end
end

def examples_dir
  File.expand_path("../example", __dir__)
end
