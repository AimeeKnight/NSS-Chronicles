class Cohort
  attr_reader :errors
  #attr_reader :name
  attr_accessor :title,
                :primary_languages,
                :term

  def initialize (title)
  #def initialize (title, primary_languages, term)
    @title = title
    #self.title = title
    #self.primary_languages = primary_languages
    #self.term = term
    @errors = []
  end

  #def to_s
    #"Title: #{title}, Primary langages: #{primary_languages}, Term: #{term}"
  #end

  def self.all
    statement = "Select * from cohorts;"
    execute_and_instantiate(statement)
  end

  def self.count
    statement = "Select count(*) from cohorts;"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.find_by_title(title)
    statement = "Select * from cohorts where title = ?;"
    execute_and_instantiate(statement, title)[0]
  end

  def self.last
    statement = "Select * from cohorts order by id DESC limit(1)"
    execute_and_instantiate(statement)[0]
  end

  def save
    if Cohort.find_by_title(self.title)
      @errors << "#{self.title} already exists."
      false
    else
      statement = "Insert into cohorts (title) values (?);"
      Environment.database_connection.execute(statement, title)
      true
    end
  end

  private

  def self.execute_and_instantiate(statement, bind_vars = [])
    rows = Environment.database_connection.execute(statement, bind_vars)
    results = []
    rows.each do |row|
      results << Cohort.new(row["title"])
    end
    results
  end
end
