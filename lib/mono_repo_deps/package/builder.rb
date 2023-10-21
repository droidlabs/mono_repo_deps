class MonoRepoDeps::Package::Builder
  include MonoRepoDeps::Mixins

  include MonoRepoDeps::Deps[
    "package.find_root",
  ]

  Contract String, String, String => MonoRepoDeps::Package
  def call(package_path, project_root, package_dirname)
    package_root_path = find_root.call(package_path, project_root)
    package_file_path = "#{package_root_path}/#{MonoRepoDeps::PACKAGE_FILENAME}"

    package = MonoRepoDeps::Package.new(package_root_path, package_dirname).tap do |p|
      p.instance_eval(File.read(package_file_path))
    end

    package
  end
end
