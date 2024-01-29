# frozen_string_literal: true

# config valid only for current version of Capistrano
lock "3.3.5"

set :rbenv_type, :user # or :system, depends on your rbenv setup
set :rbenv_ruby, "2.7.3"

set :nvm_type, :user # or :system, depends on your nvm setup
set :nvm_node, "v16.9.1"
set :nvm_map_bins, %w(node npm yarn rake)

set :application, "internos"
set :user, "aytobarcelonadecidim"
set :repo_url, "https://github.com/AjuntamentdeBarcelona/aytobarcelona-internos.git"

set :deploy_to, -> { "/home/#{fetch(:user)}/app" }
set :keep_releases, 5

set :linked_files, fetch(:linked_files, []).push("config/database.yml", "config/application.yml")
set :linked_dirs, fetch(:linked_dirs, []).push("log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "public/uploads",
                                               "storage", "tmp/webpacker-cache", "node_modules", "public/decidim-packs")

# Files that won't be copied from script/deploy/{branch}/ into the root directory
set :exclude_deployment_files, []

set :ssh_options, lambda {
  {
    user: fetch(:user),
    forward_agent: true,
    compression: "none"
  }
}

set :rails_env, "production"
set :scm, :git
set :log_level, :info

# capistrano-db-tasks related
# if you want to remove the dump file after loading
set :db_local_clean, true
# If you want to import assets, you can change default asset dir (default = system)
# This directory must be in your shared directory on the server
set :assets_dir, %w(public/assets)
# if you want to work on a specific local environment (default = ENV['RAILS_ENV'] || 'development')
set :locals_rails_env, "development"

set :passenger_restart_with_touch, true

namespace :deploy do
  desc "Decidim webpacker configuration"
  task :decidim_webpacker_install do
    on roles(:all) do
      within release_path do
        execute :npm, "install"
      end
    end
  end

  before "deploy:assets:precompile", "deploy:decidim_webpacker_install"
end
