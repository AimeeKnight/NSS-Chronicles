class Student
  attr_reader :errors
  attr_accessor :first_name,
                :last_name,
                :cohort_id

  def initialize (first_name, last_name, cohort_id)
    @first_name = first_name
    @last_name = last_name
    @cohort_id = cohort_id
  end

  #def to_s
    #"First Name: #{first_name}, Last Name: #{last_name}, Student Id: #{cohort_id}"
  #end

  def self.all
    statement = "Select * from students;"
    execute_and_instantiate(statement)
  end

  def self.count
    statement = "Select count(*) from students;"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.find_by_first_name(first_name)
    statement = "Select * from students where first_name = ?;"
    execute_and_instantiate(statement, first_name)[0]
  end

  def self.last
    statement = "Select * from students order by id DESC limit(1)"
    execute_and_instantiate(statement)[0]
  end

  def save
    if valid?
      statement = "Insert into students (first_name, last_name, cohort_id) values (?, ?, ?);"
      Environment.database_connection.execute(statement, [first_name, last_name, cohort_id])
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
      results << Student.new(row["first_name"], row["last_name"], row["cohort_id"])
    end
    results
  end
end
