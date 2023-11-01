class MonoRepoDeps::Project::Builder
  include MonoRepoDeps::Mixins

  Inject = MonoRepoDeps::Deps[
    "project.factory",
  ]

  include Inject

  sig do
    params(project_root: String).returns(MonoRepoDeps::Project)
  end
  def call(project_root)
    project_file_path = "#{project_root}/#{MonoRepoDeps::PROJECT_FILENAME}"

    project_init_proc = proc { instance_eval(File.read(project_file_path)) }

    project = factory.call(project_root, init_proc: project_init_proc)
  end
end
