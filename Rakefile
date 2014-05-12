require 'rspec/core/rake_task'
$LOAD_PATH << "lib"

RSpec::Core::RakeTask.new(:spec)

task :default => [ 'db:test:prepare', :spec ]

require 'environment'

#desc 'create the production database setup'
#task :bootstrap_database do
  #require 'environment'
  #Environment.environment = "production"
  #database = Environment.database_connection
  #database.create_tables
#end

#desc 'prepare the test database'
#task :test_prepare do
  #require 'environment'
  #test_database = "db/nss_chronicles_test.sqlite3"
  #File.delete(test_database) if File.exist?(test_database)
  #Environment.environment = "test"
  #database = Environment.database_connection
  #database.create_tables
#end

db_namespace = namespace :db do
  desc "Migrate the db"
  task :migrate do
    Environment.environment = 'production'
    Environment.connect_to_database
    ActiveRecord::Migrator.migrate("db/migrate/")
    db_namespace["schema:dump"].invoke
  end
  namespace :test do
    desc "Prepare the test database"
    task :prepare do
      Environment.environment = 'test'
      Environment.connect_to_database
      file = ENV['SCHEMA'] || "db/schema.rb"
      if File.exists?(file)
        load(file)
      else
        abort %{#{file} doesn't exist yet. Run `rake db:migrate` to create it.}
      end
    end
  end
  desc 'Rolls the schema back to the previous version (specify steps w/ STEP=n).'
  task :rollback do
    Environment.environment = 'production'
    Environment.connect_to_database
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback(ActiveRecord::Migrator.migrations_paths, step)
    db_namespace["schema:dump"].invoke
  end
  namespace :schema do
    desc 'Create a db/schema.rb file that can be portably used against any DB supported by AR'
    task :dump do
      require 'active_record/schema_dumper'
      Environment.environment = 'production'
      Environment.connect_to_database
      filename = ENV['SCHEMA'] || "db/schema.rb"
      File.open(filename, "w:utf-8") do |file|
        ActiveRecord::SchemaDumper.dump(ActiveRecord::Base.connection, file)
      end
    end
  end
end
