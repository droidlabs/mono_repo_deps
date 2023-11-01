class MonoRepoDeps::Package::Builder
  include MonoRepoDeps::Mixins

  Inject = MonoRepoDeps::Deps[
    "package.find_root",
    "package.factory"
  ]

  include Inject

  sig do
    params(
      package_path: String,
      project_root: String,
      package_dirname: String
    )
    .returns(MonoRepoDeps::Package)
  end
  def call(package_path, project_root, package_dirname)
    package_root_path = find_root.call(package_path, project_root)
    package_file_path = "#{package_root_path}/#{MonoRepoDeps::PACKAGE_FILENAME}"

    package_init_proc = proc { instance_eval(File.read(package_file_path)) }

    package = factory.call(package_root_path, package_dirname, init_proc: package_init_proc)
  end
end
