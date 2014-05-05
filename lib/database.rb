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
    self.execute("CREATE TABLE students (id INTEGER PRIMARY KEY AUTOINCREMENT, first_name varchar(50), last_name varchar(50), cohort_id INTEGER);")
    self.execute("CREATE TABLE projects (id INTEGER PRIMARY KEY AUTOINCREMENT, title varchar(50), language varchar(50), student_id INTEGER, github_url varchar(50), hosted_url varchar(50));")
    self.execute("CREATE TABLE cohort_students (id INTEGER PRIMARY KEY AUTOINCREMENT, cohort_id INTEGER, student_id INTEGER);")
  end

  def execute(statement, bind_vars = [])
    Environment.logger.info("Executing: " + statement)
    super(statement, bind_vars)
  end
end
