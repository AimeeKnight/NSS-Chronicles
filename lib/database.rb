require "sqlite3"

class Database < SQLite3::Database
  def initialize(database)
    super(database)
    self.results_as_hash = true
  end
  def self.connection(environment)
    @connection ||= Database.new("db/nss_chronicles_#{environment}.sqlite3")
  end

  def create_tables
    self.execute("CREATE TABLE cohorts (id INTEGER PRIMARY KEY AUTOINCREMENT, title varchar(50), languages varchar(75), term varchar(50));")
  end

  def execute(statement, bind_vars = [])
    Environment.logger.info("Executing: " + statement)
    super(statement, bind_vars)
  end
end
