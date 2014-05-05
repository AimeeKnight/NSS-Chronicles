class Cohort
  attr_reader :errors,
              :id
  attr_accessor :title,
                :languages,
                :term

  def initialize (title, languages, term)
    @title = title
    @languages = languages
    @term = term
  end

  def to_s
    "Title: #{title}, Languages: #{languages}, Term: #{term}"
  end

  def self.all
    statement = "Select * from cohorts;"
    execute_and_instantiate(statement)
  end

  def self.count
    statement = "Select count(*) from cohorts;"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.create(title, languages, term)
    cohort = Cohort.new(title, languages, term)
    cohort.save
    cohort
  end

  def self.find_by_title(title)
    statement = "Select * from cohorts where title = ?;"
    execute_and_instantiate(statement, title)[0]
  end

  def self.last
    statement = "Select * from cohorts order by id DESC limit(1)"
    execute_and_instantiate(statement)[0]
  end

  # join model
  #def students
    #CohortStudent.students_for_cohort(self)
  #end

  def save
    if valid?
      statement = "Insert into cohorts (title, languages, term) values (?, ?, ?);"
      Environment.database_connection.execute(statement, [title, languages, term])
      @id = Environment.database_connection.execute("SELECT last_insert_rowid();")[0][0]
      true
    else
      false
    end
  end

  def valid?
    @errors = []
    if !title.match /[a-zA-Z]/
      @errors << "'#{self.title}' is not a valid cohort title, as it does not include any letters."
    elsif Cohort.find_by_title(self.title)
      @errors << "#{self.title} already exists."
    end
    @errors.empty?
  end

  private

  def self.execute_and_instantiate(statement, bind_vars = [])
    rows = Environment.database_connection.execute(statement, bind_vars)
    results = []
    rows.each do |row|
      cohort = Cohort.new(row["title"], row["languages"], row["term"])
      cohort.instance_variable_set(:@id, row["id"])
      results << cohort
    end
    results
  end
end
