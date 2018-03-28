deploy_to   = "/home/beta_adonline/htdocs"
working_directory "#{deploy_to}/current"
pid               "#{deploy_to}/current/tmp/pids/unicorn.pid"

rails_root  = "#{deploy_to}/current"
pid_file    = "#{deploy_to}/shared/pids/unicorn.pid"
socket_file = "#{deploy_to}/shared/sockets/unicorn.sock"
log_file    = "#{rails_root}/log/unicorn.log"
err_log     = "#{rails_root}/log/unicorn_error.log"
old_pid     = pid_file + '.oldbin'

timeout          30
worker_processes 2
listen           socket_file, :backlog => 1024
pid              pid_file
stderr_path      err_log
stdout_path      log_file
preload_app      true

stderr_path "log/unicorn.stderr.log"
stdout_path "log/unicorn.stdout.log"

# use correct Gemfile on restarts
before_exec do |server|
  ENV['BUNDLE_GEMFILE'] = "#{deploy_to}/current/Gemfile"
end

preload_app true

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end

GC.copy_on_write_friendly = true if GC.respond_to?(:copy_on_write_friendly=)
