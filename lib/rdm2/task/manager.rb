class Rdm2::Task::Manager
  include Rdm2::Mixins

  # Contract Symbol, Maybe[ArrayOf[Any]] => Rdm2::Config
  def method_missing(method_name, *args, **kwargs)
    task = Rdm2.current_project.tasks.detect { _1.name == method_name } || (raise StandardError.new("task '#{method_name}' not found for project"))

    case task.on
    when :package
      statuses = kwargs[:packages].inject({}) do |result, package|
        result[package.name] = do_in_child(task.block, package, kwargs[:args])
        result
      end

      failed_packages = statuses.reject {|package_name, exitstatus| exitstatus.success?}

      if failed_packages.any?
        puts failed_packages.keys
        exit 1
      end
    else
      raise StandardError.new("unsupported task subject: #{task.on}")
    end
  end

  private

  def do_in_child(block, *args)
    read, write = IO.pipe

    pid = fork do
      read.close
      block.call(*args)
    end

    write.close
    Process.wait(pid)

    exit($?.exitstatus)
  end
end