# frozen_string_literal: true

# config valid for current version and patch releases of Capistrano
lock '~> 3.19.2'

server '3.143.142.188', roles: %i[web app db], primary: true
set :application, 'propmaticly'
set :repo_url, 'git@github.com:coderalert0/propmaticly.git'
set :branch, 'main'
set :keep_releases, 3
set :user, 'ubuntu'

set :pty, true
set :use_sudo, true
set :systemd_unit, -> { 'delayed_job' }
set :systemd_use_sudo, true
set :systemd_roles, %w[app]
set :stage, :production
set :deploy_via, :remote_cache
set :deploy_to, "/home/#{fetch(:user)}/#{fetch(:application)}"
set :delayed_job_systemd_unit_name, 'delayed_job'
set :puma_service_unit_name, 'puma'
set :puma_systemctl_user, :system
set :puma_bind, "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log, "#{release_path}/log/puma.error.log"
set :ssh_options, { forward_agent: true, user: fetch(:user), keys: %w[~/.ssh/id_rsa.pub] }
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true # Change to false when not using ActiveRecord

append :linked_files, 'config/master.key'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'public/uploads'

after 'deploy:publishing', 'nginx:restart'
