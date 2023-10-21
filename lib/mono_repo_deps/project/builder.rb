class MonoRepoDeps::Project::Builder
  include MonoRepoDeps::Mixins

  Contract String => MonoRepoDeps::Project
  def call(project_root)
    project_file_path = "#{project_root}/#{MonoRepoDeps::PROJECT_FILENAME}"

    project = MonoRepoDeps::Project.new(File.dirname(project_file_path))
    project.instance_eval(File.read(project_file_path))

    project
  end
end
