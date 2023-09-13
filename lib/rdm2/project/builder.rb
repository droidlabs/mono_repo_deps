class Rdm2::Project::Builder
  include Rdm2::Mixins

  include Rdm2::Deps[
    "project.find_root",
    package_builder: "package.builder",
  ]

  Contract String => Rdm2::Project
  def call(dir)
    project_root = find_root.call(dir)
    project_file = "#{project_root}/#{Rdm2::PROJECT_FILENAME}"
    packages_path = "#{project_root}/**/#{Rdm2::PACKAGE_FILENAME}"

    project = Rdm2::Project.new(project_root, )
    project.instance_eval(File.read(project_file))
    project.set_packages(
      Dir[packages_path].map do |package_file_path|
        package_builder.call(File.dirname(package_file_path), project.root_path, project.package_dir)
      end
    )

    project
  end
end