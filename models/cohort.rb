class Cohort
  attr_reader :errors
  #attr_reader :name
  attr_accessor :title,
                :languages,
                :term

  def initialize (title, languages, term)
  #def initialize (title, primary_languages, term)
    @title = title
    #self.title = title
    @languages = languages
    @term = term
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
    if !title.match /[a-zA-Z]/
      @errors << "'#{self.title}' is not a valid cohort title, as it does not include any letters."
      false
    elsif Cohort.find_by_title(self.title)
      @errors << "#{self.title} already exists."
      false
    else
      statement = "Insert into cohorts (title, languages, term) values (?, ?, ?);"
      Environment.database_connection.execute(statement, [title, languages, term])
      true
    end
  end

  private

  def self.execute_and_instantiate(statement, bind_vars = [])
    rows = Environment.database_connection.execute(statement, bind_vars)
    results = []
    rows.each do |row|
      results << Cohort.new(row["title"], row["languages"], row["term"])
    end
    results
  end
end
