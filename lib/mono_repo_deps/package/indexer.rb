class MonoRepoDeps::Package::Indexer
  include MonoRepoDeps::Mixins

  include MonoRepoDeps::Deps[
    "package.builder",
  ]

  Contract String, String, String => ArrayOf[MonoRepoDeps::Package]
  def call(packages_lookup_subdir, project_root, package_dirname)
    packages_path = File.join(
      project_root,
      packages_lookup_subdir,
      "**",
      MonoRepoDeps::PACKAGE_FILENAME
    )

    Dir[packages_path].map do |package_file_path|
      builder.call(package_file_path, project_root, package_dirname)
    end
  end
end
