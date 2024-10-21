class MonoRepoDeps::Task::Manager
  include MonoRepoDeps::Mixins

  Inject = MonoRepoDeps::Deps[
    packages_repo: "package.repo"
  ]

  include Inject

  sig do
    params(
      method_name: Symbol,
      args: T.anything,
      kwargs: T.anything
    )
    .returns(T::Boolean)
  end
  def method_missing(method_name, *args, **kwargs)
    task = MonoRepoDeps.current_project.tasks.detect { _1.name == method_name } || (raise StandardError.new("task '#{method_name}' not found for project"))

    case task.on
    when :package
      statuses = kwargs[:packages].inject({}) do |result, package_name|
        package = packages_repo.find!(package_name.to_sym)
        result[package.name] = task.block.call(package, kwargs[:args])
        result
      end

      failed_packages = statuses.reject {|package_name, exitstatus| exitstatus == 0}

      failed_packages.any? ? false : true
    else
      raise StandardError.new("unsupported task subject: #{task.on}")
    end
  end
end
