class Rdm2::Project::Builder
  include Rdm2::Mixins

  include Rdm2::Deps[
    "project.find_root",
    package_builder: "package.builder",
  ]

  Contract String => Rdm2::Project
  def call(dir)
    Rdm2.project ||= begin
      project_root = find_root.call(dir)
      project_file = "#{project_root}/#{Rdm2::PROJECT_FILENAME}"
      packages_path = "#{project_root}/**/#{Rdm2::PACKAGE_FILENAME}"

      project = Rdm2::Project.new(project_root).tap do |p|
        p.instance_eval(File.read(project_file))

        p.set_packages(
          Dir[packages_path].map do |package_file_path|
            package_builder.call(File.dirname(package_file_path), project_root)
          end
        )
      end

      project
    end
  end
end