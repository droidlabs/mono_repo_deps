require 'singleton'

class Rdm2::Project::ProjectLoader
  include Singleton

  def load
    Rdm2::Project::RootLocator.instance.find_root(".")
  end
end