class MonoRepoDeps::Project::Builder
  include MonoRepoDeps::Mixins

  include MonoRepoDeps::Deps[
    "project.find_root",
    package_builder: "package.builder",
  ]

  Contract String => MonoRepoDeps::Project
  def call(dir)
    project_root = find_root.call(dir)
    project_file = "#{project_root}/#{MonoRepoDeps::PROJECT_FILENAME}"

    project = MonoRepoDeps::Project.new(project_root, )
    project.instance_eval(File.read(project_file))

    packages_path = File.join(
      project.root_path,
      project.packages_folder,
      "**",
      MonoRepoDeps::PACKAGE_FILENAME
    )

    project.set_packages(
      Dir[packages_path].map do |package_file_path|
        package_builder.call(File.dirname(package_file_path), project.root_path, project.package_dir)
      end
    )

    project
  end
end