class Student
  attr_reader :errors,
              :id
  attr_accessor :first_name,
                :last_name,
                :cohort_id

  def initialize (first_name, last_name, cohort_id)
    @first_name = first_name
    @last_name = last_name
    @cohort_id = cohort_id
    @alumni = false
  end

  def to_s
    "Id: #{@id}, First Name: #{first_name}, Last Name: #{last_name}, Cohort Id: #{cohort_id}, Alumni: #{@alumni}"
  end

  def self.all
    statement = "Select * from students;"
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
    result = Environment.database_connection.execute(statement, cohort.id)
    return nil if result.empty?
    result
    #map and create students
  end

  def self.for_project(cohort)
    statement = "Select projects.title, students.first_name, students.last_name
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
    statement = "Update students set alumni = 1 where id = ?;"
    Environment.database_connection.execute(statement, self.id)[0]
    @alumni = true
  end

  def projects
    Project.for_student(self)
  end

  def save
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

  private

  def self.execute_and_instantiate(statement, bind_vars = [])
    rows = Environment.database_connection.execute(statement, bind_vars)
    results = []
    rows.each do |row|
      student = Student.new(row["first_name"], row["last_name"], row["cohort_id"])
      student.instance_variable_set(:@id, row["id"])
      results << student
    end
    results
  end
end
