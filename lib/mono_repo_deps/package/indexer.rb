class MonoRepoDeps::Package::Indexer
  include MonoRepoDeps::Mixins

  Inject = MonoRepoDeps::Deps[
    "package.builder",
  ]

  include Inject

  sig do
    params(
      packages_lookup_subdir: String,
      project_root: String,
      package_dirname: String
    )
    .returns(T::Array[MonoRepoDeps::Package])
  end
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
