# frozen_string_literal: true

require "chamber/commands/securable"
require "chamber/commands/secure"
require "pathname"

namespace :chamber do
  desc "Secure all keys from every environment"
  task :secure_all do
    environments = Pathname.new(Rails.root.join("script/deploy")).children.select(&:directory?).map { |c| c.basename.to_s } << "development" # nil for development configuration
    environments.each do |environment|
      puts "Securing #{environment || "development"} environment"
      Rake::Task["chamber:secure"].execute(environment: environment)
    end
  end

  desc "Secure keys"
  task :secure, [:environment] do |_t, args|
    environment = args[:environment] || "development"

    basepath = environment != "development" ? Rails.root.join("script/deploy/#{environment}/config") : Rails.root.join("config")
    encryption_key = File.join(basepath.to_s, "chamber.pem.pub")
    files = [
      File.join(basepath.to_s, "settings.yml"),
      File.join(basepath.to_s, "settings", "*.{yml,yml.erb}")
    ]

    puts "Basepath : #{basepath}"
    puts "Encryption_key : #{encryption_key}"
    puts "Files path : #{files}"

    if File.exist? encryption_key
      puts "Encrypting #{environment} environment"
      options = {
        rootpath: Rails.root,
        basepath: basepath,
        encryption_key: encryption_key,
        files: files
      }

      # system "bundle exec chamber secure --basepath=#{basepath} --encryption-key=#{encryption_key} --files=#{files}"
      chamber_instance = Chamber::Instance.new(options)
      chamber_instance.secure
    else
      puts "No encryption file for #{environment}"
    end

    puts "\n\n"
  end

  def prepare_params(args)
    args.each do |arg|
      # rubocop:disable Style/BlockDelimiters
      task arg.to_sym do; end
      # rubocop:enable Style/BlockDelimiters
    end
    args
  end
end
