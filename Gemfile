# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = "0.27.5"

gem "decidim", DECIDIM_VERSION
gem "decidim-consultations", DECIDIM_VERSION

gem "decidim-direct_verifications", git: "https://github.com/Platoniq/decidim-verifications-direct_verifications", branch: "release/0.27-stable"
gem "decidim-term_customizer", git: "https://github.com/mainio/decidim-module-term_customizer", branch: "release/0.27-stable"

gem "omniauth-saml", "~> 2.0"

# Metrics require a queue system and a daily cron
gem "delayed_job_active_record"
# daemons: required to manage the delayed_job background process
gem "daemons"
gem "whenever", require: false

gem "bootsnap", "~> 1.3"

gem "puma", ">= 5.0.0"

gem "faker", "~> 2.14"

gem "wicked_pdf", "~> 2.1"

gem "deface", "~> 1.9"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "rubocop-faker"

  gem "brakeman"
  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.2"

  gem "capistrano", "~> 3.14"
  gem "capistrano3-delayed-job", "~> 1.0"
  gem "capistrano-bundler", "~> 1.2"
  gem "capistrano-nvm"
  gem "capistrano-passenger"
  gem "capistrano-rails"
  gem "capistrano-rbenv"
end

group :production do
  gem "figaro", "~> 1.2"
end
