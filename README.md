# MonoRepoDeps

Dependency manager to split and organize Ruby modules and namespaces into highlevel packages and manage relations between them
Next version of [Rdm gem](https://github.com/droidlabs/rdm)

## Idea
Main goal to implement the gem was to give developers an ability to keep a large codebase in the single git repository (monorepository) with easy access to:
1) require only needed dependencies
2) set up loading policies and inflection rules
3) manage configuration for different environments
4) run specific tasks on selected packages

## Example Project File Structure
```bash
  ├── MonoRepoConfig.rb
  ├── Gemfile
  ├── Gemfile.lock
  ├── bounded_contexts
  │   ├── orders
  │   │   ├── bin
  │   │   │   └── run
  │   │   ├── package
  │   │   │   ├── orders
  │   │   │   │   └── export_orders.rb
  │   │   │   │
  │   │   │   └── orders.rb
  │   │   │
  │   │   └── Package.rb
  │   │
  │   ├── orders_db
  │   │   ├── package
  │   │   │   └── orders_db.rb
  │   │   │
  │   │   └── Package.rb
  │   │
  │   └── cart
  │       ├── package
  │       │   └── orders.rb
  │       │
  │       └── Package.rb
  │
  └── configs
      ├── orders_config
      │   ├── default.yml
      │   └── test.yml
      │
      └── api_client_config
          ├── default.yml
          └── test.yml
```

## Package
  The main MonoRepoDeps entity is the "package".
  Package configuration is defined in Package.rb file.
  Each package also have an 'entrypoint' file, which can be defined as package namespace module.

  For example for orders package from project structure above entrypoint file could look the following way:
  ```ruby
    module Orders
    end

    require 'some_gem'

    SomeGem.example_initialization_for(__dir__)
  ```

  You can declare dependencies rules which will determine what packages should be imported before you will initialize current one
  ```ruby
    # ./bounded_contexts/orders/Package.rb

    package do
      name    'marketplace'
    end

    dependency do
      import 'orders_db'
    end

    dependency :test do
      import 'cart'
    end
  ```

  Having that configuration you can call the following code in your bin/run file
  ```bash
    #!/usr/bin/env ruby
    require 'bundler/setup'
    require 'mono_repo_deps'
    MonoRepoDeps.init_package

    Orders::ExportOrders.new.call
  ```

  Let's take a look at ```MonoRepoDeps.init_package``` command. That is the core feature of MonoRepoDeps and it does the following actions
  1. Detect which package the caller file belongs to
  You can also provide that file directly using 'from:' parameter
  ```MonoRepoDeps.init_package(from: __FILE__)```
  or providing package name
  ```MonoRepoDeps.init_package('orders')```
  2. Build dependencies tree: inside each project we have ```dependency do; end``` block which is provide us information which packages should be loaded before the current one
  3. For each file in dependency tree:
      * Using Project Code Loader to autoload/preload package classes and modules
      * Call ```require``` for entrypoint file

## Configs
  MonoRepoDeps Configs provides interface to declare and access key-value storage can be specified for certain environment

  Instead of using ENV['SOME_VARIABLE_NAME'] in your ruby files you can set up MonoRepoDeps Configs and use env variables in your code like this:
  ```ruby
    MonoRepoDeps.configs.api_client.some_variable_name
  ```
  Let's define MonoRepoDeps Config for ```api_client```
  ```yml
    # ./configs/api_client/default.yml
    api_client:
      some_variable_name: ENV['SOME_VARIABLE_NAME']

    # ./configs/api_client/test.yml
    api_client:
      some_variable_name: ENV['SOME_VARIABLE_NAME'] + ENV['TEST_ENV_NUMBER']
  ```

  Rdm looks up for configs in directory have been set in MonoRepoConfig.rb file with ```set_configs_dir``` method
  Each config has at least default.yml configuration which can be complemented with :env.yml files
  Running ```MonoRepoDeps.init_package``` with specified :env will check if corresponding :env.yml file exists and merge it's values to the default configuration

## Project
  The 2 main entities within MonoRepoDeps project are 'project' and 'package'
  Project declaration stored in MonoRepoConfig.rb and a parent directory of the file is considered as the project root

  ### Project Configuration File Example

  ```ruby
    setup do |project|
      # set up project.env
      set_env(ENV['RUBY_ENV'] || raise('RUBY_ENV environment variable is not set'))

      # set up directory to look up for project configs
      set_configs_dir 'configs'

      # set up directory to look up for packages
      set_package_dirname 'package'
      set_packages_lookup_subdir 'bounded_contexts'

      # code loader configuration
      set_loader :zeitwerk do
        # file patterns to exclude in ruby autoloading
        ignore "**/schema_migrations"
        ignore "**/data_migrations"

        # rules to overwrite default filename-to-class strategy
        overwrite ->(kname) { kname.gsub(/Foo/) { _1.upcase } }
        overwrite ->(kname) { kname.gsub('Baz', 'BazBar') }

        # another way to define inflection rules
        inflect "uuid_generator" => "UUIDGenerator"
      end

      # definition of the task to run rspec on the specific package
      register_task :rspec_run, on: :package do |package, args|
        Dir.chdir(package.root_path) do
          require 'rspec'

          status = RSpec::Core::Runner.run(args, $stderr, $stdout).to_i

          exit(status)
        end
      end
    end
  ```

## Tasks
  MonoRepoDeps tasks are an easy way to declare some procedures can be called on you packages/package

  ### Examples
  ```ruby
    # MonoRepoConfig.rb
      setup do |project|
        # ...
        register_task :puts_package_name, on: :package do |package, args|
          puts [package.name, args].inspect
        end
        # ...
      end
  ```

  You can call defined task that way:
  ```ruby
    MonoRepoDeps.tasks.puts_package_name(
      packages: MonoRepoDeps.packages.filter(name: "orders"),
      args: [1, 2, 3]
    )
  ```