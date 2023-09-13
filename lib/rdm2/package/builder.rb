class Rdm2::Package::Builder
  include Rdm2::Mixins

  include Rdm2::Deps[
    "package.find_root",
  ]

  Contract String, String, String => Rdm2::Package
  def call(package_path, project_root, package_dir)
    package_root = find_root.call(package_path, project_root)
    package_file = "#{package_root}/#{Rdm2::PACKAGE_FILENAME}"

    package = Rdm2::Package.new(package_root, package_dir).tap do |p|
      p.instance_eval(File.read(package_file))
    end

    package
  end
end