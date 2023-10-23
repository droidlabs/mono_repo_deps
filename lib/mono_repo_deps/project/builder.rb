class MonoRepoDeps::Project::Builder
  include MonoRepoDeps::Mixins

  include MonoRepoDeps::Deps[
    "project.factory",
  ]

  Contract String => MonoRepoDeps::Project
  def call(project_root)
    project_file_path = "#{project_root}/#{MonoRepoDeps::PROJECT_FILENAME}"

    project = factory.call(project_root) do
      instance_eval(File.read(project_file_path))
    end
  end
end
