# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = "~> 0.30.1"

gem "decidim", DECIDIM_VERSION

gem "decidim-decidim_awesome", git: "https://github.com/decidim-ice/decidim-module-decidim_awesome", branch: "main"
gem "decidim-direct_verifications", git: "https://github.com/Platoniq/decidim-verifications-direct_verifications", branch: "main"
gem "decidim-term_customizer", git: "https://github.com/Platoniq/decidim-module-term_customizer", branch: "main"

gem "omniauth-saml", "~> 2.0"

# Metrics require a queue system and a daily cron
gem "delayed_job_active_record"
# daemons: required to manage the delayed_job background process
gem "daemons"
gem "whenever", require: false

gem "bootsnap", "~> 1.3"

gem "puma", ">= 5.0.0"

gem "faker"

gem "wicked_pdf", "~> 2.1"

gem "deface", "~> 1.9"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "mdl"
  gem "rubocop-faker"

  gem "brakeman"
  gem "decidim-dev", DECIDIM_VERSION

  gem "debug"
  gem "ruby-lsp", require: false
  gem "ruby-lsp-rails", require: false
  gem "ruby-lsp-rspec", require: false
end

group :development do
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
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
