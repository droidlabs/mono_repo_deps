class MonoRepoDeps::Package::Builder
  include MonoRepoDeps::Mixins

  include MonoRepoDeps::Deps[
    "package.find_root",
  ]

  Contract String, String, String => MonoRepoDeps::Package
  def call(package_path, project_root, package_dir)
    package_root = find_root.call(package_path, project_root)
    package_file = "#{package_root}/#{MonoRepoDeps::PACKAGE_FILENAME}"

    package = MonoRepoDeps::Package.new(package_root, package_dir).tap do |p|
      p.instance_eval(File.read(package_file))
    end

    package
  end
end