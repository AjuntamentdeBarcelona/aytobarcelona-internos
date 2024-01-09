# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = { git: "https://github.com/decidim/decidim.git", branch: "release/0.25-stable" }.freeze

gem "activerecord-session_store"
gem "chamber", "~> 2.12.1"
# Change term_customizer dependency to ruby-gems' when term-customizer is compatible with DECIDIM_bVERSION
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer", branch: "release/0.25-stable"

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION
gem "decidim-direct_verifications", "~> 1.2.0"
gem "omniauth-saml", "~> 2.0"

# Metrics require a queue system and a daily cron
gem "delayed_job_active_record"
# daemons: required to manage the delayed_job background process
gem "daemons"
gem "whenever", require: false

gem "bootsnap", "~> 1.3"

gem "puma", "~> 5.0"
gem "uglifier", "~> 4.1"

gem "deface"
gem "httplog"

group :development, :test do
  gem "byebug", platform: :mri
  gem "decidim-dev", DECIDIM_VERSION
  gem "faker", "~> 2.14"
  gem "rspec-rails"
end

group :development do
  gem "airbrussh", require: false
  gem "capistrano", "3.3.5"
  gem "capistrano3-delayed-job", "~> 1.0"
  gem "capistrano-bundler", "~> 1.2"
  gem "capistrano-db-tasks", require: false
  gem "capistrano-faster-assets", "~> 1.0"
  gem "capistrano-passenger"
  gem "capistrano-rails"
  gem "letter_opener_web", "~> 1.3"
  gem "listen", "~> 3.1"
  gem "rubocop-faker"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 3.5"
end
