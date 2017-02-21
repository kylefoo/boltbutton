# config valid only for current version of Capistrano
lock '3.7.2'

set :application, 'boltbutton'
set :repo_url, 'git@github.com:kylefoo/boltbutton.git'

set :rbenv_path, '~/.rbenv'
set :rbenv_type, :system
set :rbenv_ruby, '2.3.1'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value
# set :normalize_asset_timestamps, false
set :normalize_asset_timestamps, %{public/images public/javascripts public/stylesheets}

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('config/database.yml', 'config/secrets.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/uploads')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 2

# set :sidekiq_options, "--queue default --queue mailers"
# set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

# Remote database syncing
set :disallow_pushing, true
set :db_local_clean, true
set :db_remote_clean, true

namespace :deploy do

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end

namespace :rails do
  desc "Tail rails error logs from server"
  task :log do
    on roles(:app) do
      execute "tail -f /var/log/nginx/error.log"
    end
  end

  desc "Tail rails access logs from server"
  task :log_access do
    on roles(:app) do
      execute "tail -f /var/log/nginx/access.log"
    end
  end

  desc "Tail cron logs from server"
  task :log_cron do
    on roles(:app) do
      execute "tail -f /var/log/cron.log"
    end
  end

  desc "Database Console"
  task :console do
    on roles(:app) do
      execute "cd /var/www/tourplus/current && rails console #{:rails_env}"
    end
  end
end

end