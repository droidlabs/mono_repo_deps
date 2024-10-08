class MonoRepoDeps::Package::FindRoot
  include MonoRepoDeps::Mixins

  SYSTEM_ROOT = '/'

  sig do
    params(
      dir: String,
      project_root: T.nilable(String),
    )
    .returns(String)
  end
  def call(dir, project_root)
    init_dir = dir = File.expand_path(dir)
    project_root = File.expand_path(project_root || SYSTEM_ROOT)

    unless File.exist?(init_dir)
      raise StandardError.new("path '#{init_dir}' does not exist")
    end

    loop do
      project_file_path = File.expand_path(File.join(dir, MonoRepoDeps::PACKAGE_FILENAME))

      if File.exist?(project_file_path)
        return dir
      elsif dir == project_root
        raise StandardError.new("Package.rb for path '#{init_dir}' not found")
      else
        dir = File.expand_path("../", dir)
      end
    end
  end
end
