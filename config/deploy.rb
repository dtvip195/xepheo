# config valid for current version and patch releases of Capistrano
lock "~> 3.17.2"

# Tên application của mình
set :application, 'xepheo' 
set :user, 'deploy'
# Repository github của bạn. Tạo 1 repo mới trên github
set :repo_url, 'git@github.com:dtvip195/xepheo.git' 
set :branch, :main
set :deploy_to, '/home/deploy/xepheo'
set :pty, true
set :linked_files, %w{config/database.yml config/application.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :keep_releases, 5
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-3.2.0' 

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false

namespace :puma do
  task :restart do
    puts "Overwriting puma:restart to ensure that puma is running. Effectively, we are just starting Puma."
    puts "A solution to this should be found."
    puts "Taken from https://stackoverflow.com/questions/44763777/capistrano-pumarestart-not-working-but-pumastart-does"
    invoke 'puma:stop'
    invoke 'puma:start'
  end
end

namespace :deploy do
  desc 'Restart application'
    task :restart do
      on roles(:app), in: :sequence, wait: 5 do
        invoke 'puma:restart'
      end
  end
end
