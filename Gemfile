# frozen_string_literal: true

source 'https://rubygems.org'

ruby RUBY_VERSION

DECIDIM_VERSION = { git: 'https://github.com/decidim/decidim.git', branch: '0.20-stable' }

gem 'activerecord-session_store'
gem 'chamber', '~> 2.10.1'
# Change term_customizer dependency to ruby-gems' when term-customizer is compatible with DECIDIM_VERSION
gem 'decidim-term_customizer', git: "https://github.com/CodiTramuntana/decidim-module-term_customizer"

gem 'decidim', DECIDIM_VERSION
gem 'decidim-consultations', DECIDIM_VERSION
gem 'decidim-direct_verifications', '0.17.8'
gem 'omniauth-saml'

# Metrics require a queue system and a daily cron
gem 'delayed_job_active_record'
# daemons: required to manage the delayed_job background process
gem 'daemons'
gem 'whenever', require: false

gem 'bootsnap', '~> 1.3'

gem 'rails', '< 6'
# can't update until decicim-dev is higher gem 'puma', '~> 4.3'
gem 'puma', '~> 3.12'
gem 'uglifier', '~> 4.1'
# geocoder can not be upgraded to 1.6 until the Here maps api key is changed for the new one
gem "geocoder", "~> 1.5.2"

gem 'httplog'
gem "deface"

group :development, :test do
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'decidim-dev', DECIDIM_VERSION
  gem 'faker', '~> 1.9'
end

group :development do
  gem 'airbrussh', require: false
  gem 'capistrano', '3.3.5'
  gem 'capistrano-bundler', '~> 1.2'
  gem 'capistrano-db-tasks', require: false
  gem 'capistrano-faster-assets', '~> 1.0'
  gem 'capistrano-passenger'
  gem 'capistrano-rails'
  gem 'capistrano3-delayed-job', '~> 1.0'
  gem 'letter_opener_web', '~> 1.3'
  gem 'listen', '~> 3.1'
  gem 'spring', '~> 2.0'
  gem 'spring-watcher-listen', '~> 2.0'
  gem 'web-console', '~> 3.5'
end
