class MonoRepoDeps::Project::Initializer
  include MonoRepoDeps::Mixins

  include MonoRepoDeps::Deps[
    "package.indexer",
    "project.builder",
    "project.find_root"
  ]

  Contract String => MonoRepoDeps::Project
  def call(dir)
    project_root = find_root.call(dir)

    project = builder.call(project_root)
    project_packages = indexer.call(project.packages_lookup_subdir, project.root_path, project.package_dirname)

    project.set_packages(project_packages)

    project
  end
end
