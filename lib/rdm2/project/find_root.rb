require 'zeitwerk'
require 'singleton'

class Rdm2::Project::FindRoot
  include Rdm2::Mixins

  SYSTEM_ROOT = '/'

  Contract String => String
  def call(dir)
    init_dir = dir = File.expand_path(dir)

    unless Dir.exists?(init_dir)
      raise StandardError.new("path '#{init_dir}' does not exist")
    end

    loop do
      project_file_path = File.expand_path(File.join(dir, Rdm2::PROJECT_FILENAME))

      if File.exists?(project_file_path)
        return dir
      elsif dir == SYSTEM_ROOT
        raise StandardError.new("Rdm.packages for path '#{init_dir}' not found")
      else
        dir = File.expand_path("../", dir)
      end
    end
  end
end