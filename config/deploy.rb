# config valid only for current version of Capistrano
lock '3.4.0'
set :rvm_type, '/usr/local/rvm'
set :rvm_custom_path, '/usr/local/rvm'
set :rvm_ruby_version, '2.1.0'

# set :application, 'edbox'
set :repo_url, 'git@github.com:parfenov23/site_tobacco_gold.git'
# set :user, 'edbox'
# set :deploy_to, "/home/#{ fetch :user }/htdocs"

set :linked_files, fetch(:linked_files, []).push('config/database.yml',
                                                 'config/secrets.yml')

set :linked_dirs, fetch(:linked_dirs, []).push('log',
                                               'tmp/pids',
                                               'tmp/cache',
                                               'tmp/sockets',
                                               'vendor/bundle',
                                               'public/system')

set :pty, false
set :keep_releases, 3
set :whenever_roles, [:app]
set :deploy_via, :copy
set :copy_cache, false
# set :slack_webhook, "https://hooks.slack.com/services/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"

# load 'lib/tasks/resque.rake'

namespace :deploy do
  after 'deploy:publishing', 'deploy:restart'
  # , 'deploy:websocket_restart'
  #
  # task :resque_restart do
  #   `RAILS_ENV=production bundle exec rake resque:restart_workers`
  # end

  task :restart do
    invoke 'unicorn:legacy_restart'
  end

  task :start do
    invoke 'unicorn:start'
  end

  task :stop do
    invoke 'unicorn:stop'
  end

  # task :websocket_restart do
  #   `ps aux | grep websocket_rails | awk '{print $2}' | xargs kill -9`
  #   `RAILS_ENV=production bundle exec rake websocket_rails:start_server`
  # end
  #
  #
  # task :websocket_stop do
  #   `rake websocket:stop_server`
  # end
  # after "deploy", 'resque:restart_workers'
end
