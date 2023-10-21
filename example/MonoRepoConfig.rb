setup do |project|
  set_env ->() { :test }

  set_configs_dir 'configs'
  set_package_dirname 'package'

  set_loader :zeitwerk do
    inflect 'filename' => "FileName"
    overwrite ->(klass_name) { klass_name.gsub(/Api/) { _1.upcase } }
    ignore "#{project.root_path}/**/schema_migrations"
  end

  register_task :print_package_name, on: :package do |package, args|
    puts package.entrypoint_file
  end
end
