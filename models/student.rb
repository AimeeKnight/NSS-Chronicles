class Student
  attr_reader :errors,
              :id
  attr_accessor :first_name,
                :last_name,
                :cohort_id,
                :alumni

  def initialize (first_name, last_name, cohort_id, alumni = false)
    @first_name = first_name
    @last_name = last_name
    @cohort_id = cohort_id
    @alumni = alumni
  end

  def to_s
    "ID: #{@id}, FIRST NAME: #{first_name}, LAST NAME: #{last_name}, COHORT ID: #{cohort_id}, ALUMNI: #{@alumni}"
  end

  def self.join_to_s(result)
    "TITLE: #{result["title"]}, LANGUAGE: #{result["language"]}, STUDENT NAME: #{result["first_name"]} #{result["last_name"]}"
  end

  def self.all
    statement = "Select * from students;"
    execute_and_instantiate(statement)
  end

  def self.alumni
    statement = "Select * from students where alumni = 1;"
    execute_and_instantiate(statement)
  end

  def self.current
    statement = "Select * from students where alumni = 0;"
    execute_and_instantiate(statement)
  end

  def self.count
    statement = "Select count(*) from students;"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.create(first_name, last_name, cohort_id)
    student = Student.new(first_name, last_name, cohort_id)
    student.save
    student
  end

  def self.for_cohort(cohort)
    statement = "Select * from students where cohort_id = ?;"
    result = execute_and_instantiate(statement, cohort.id)
    return nil if result.empty?
    result
  end

  def self.projects_from_cohort(cohort)
    statement = "Select distinct projects.title, projects.language, students.first_name, students.last_name
                 from projects
                 join students
                   on students.id = projects.student_id
                 join cohorts
                   on ? = students.cohort_id"
    result = Environment.database_connection.execute(statement, cohort.id)
    return nil if result.empty?
    result
  end

  def self.find_by_first_name(first_name)
    statement = "Select * from students where first_name = ?;"
    execute_and_instantiate(statement, first_name)[0]
  end

  def self.find_by_first_and_last_name(first_name, last_name)
    statement = "Select * from students where first_name = ? and last_name = ?;"
    execute_and_instantiate(statement, [first_name, last_name])[0]
  end

  def self.find_by_id(id)
    statement = "Select * from students where id = ?;"
    execute_and_instantiate(statement, id)[0]
  end

  def self.last
    statement = "Select * from students order by id DESC limit(1)"
    execute_and_instantiate(statement)[0]
  end

  def alumni?
    @alumni
  end

  def make_alumni
    self.alumni = 1
    self.save
    @alumni = true
  end

  def projects
    Project.for_student(self)
  end

  def save
    if self.id
      statement = "Update students set first_name = ?, last_name = ?, cohort_id = ?, alumni = ? where id = ?;"
      Environment.database_connection.execute(statement, [self.first_name, self.last_name, self.cohort_id, self.alumni, self.id])[0]
    end
    if valid?
      statement = "Insert into students (first_name, last_name, cohort_id, alumni) values (?, ?, ?, ?);"
      Environment.database_connection.execute(statement, [first_name, last_name, cohort_id, 0])
      @id = Environment.database_connection.execute("SELECT last_insert_rowid();")[0][0]
      true
    else
      false
    end
  end

  def valid?
    @errors = []
    if !first_name.match /[a-zA-Z]/
      @errors << "'#{self.first_name}' is not a valid student first name, as it does not include any letters."
    elsif Student.find_by_first_name(self.first_name)
      @errors << "#{self.first_name} already exists."
    end
    @errors.empty?
  end

  def self.format_boolean(value)
    if value == 1
      value = true
    elsif value == 0
      value = false
    end
  end

  private

  def self.execute_and_instantiate(statement, bind_vars = [])
    rows = Environment.database_connection.execute(statement, bind_vars)
    results = []
    rows.each do |row|
      student = Student.new(row["first_name"], row["last_name"], row["cohort_id"], row["alumni"])
      student.instance_variable_set(:@id, row["id"])
      student.instance_variable_set(:@alumni, format_boolean(row["alumni"]))
      results << student
    end
    results
  end
end
