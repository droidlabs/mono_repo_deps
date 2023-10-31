class MonoRepoDeps::Project::Initializer
  include MonoRepoDeps::Mixins

  Inject = MonoRepoDeps::Deps[
    "package.indexer",
    "project.builder",
    "project.find_root"
  ]

  include Inject

  sig do
    params(dir: String).returns(MonoRepoDeps::Project)
  end
  def call(dir)
    project_root = find_root.call(dir)

    project = builder.call(project_root)

    project_packages = indexer.call(project.packages_lookup_subdir, project.root_path, project.package_dirname)

    project.set_packages(project_packages)

    project
  end
end
