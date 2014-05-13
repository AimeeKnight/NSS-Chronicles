require 'rubygems'
require 'bundler/setup'
require 'active_record'

project_root = File.dirname(File.absolute_path(__FILE__))
Dir.glob(project_root + "/../models/*.rb").each{|f| require f}

I18n.enforce_available_locales = false
require 'logger'

class Environment
  def self.environment= environment
    @@environment = environment
    Environment.connect_to_database
  end

  def self.connect_to_database
    connection_details = YAML::load(File.open('config/database.yml'))
    ActiveRecord::Base.establish_connection(connection_details[@@environment])
  end

  def self.logger
    @@logger ||= Logger.new("log/#{@@environment}.log")
  end
end
