class Project
  attr_reader :errors,
              :id
  attr_accessor :title,
                :language,
                :student_id,
                :github_url,
                :hosted_url

  def initialize(title, language, student_id, github_url, hosted_url)
    self.title = title
    self.language = language
    self.student_id = student_id
    self.github_url = github_url
    self.hosted_url = hosted_url
  end

  def to_s
    "ID: #{@id}, TITLE: #{title}, LANGUAGE: #{language}, STUDENT ID: #{student_id}, GITHUB URL: #{github_url}, HOSTED URL: #{hosted_url}"
  end

  def self.all
    statement = "Select * from projects;"
    execute_and_instantiate(statement)
  end

  def self.count
    statement = "Select count(*) from projects;"
    result = Environment.database_connection.execute(statement)
    result[0][0]
  end

  def self.create(title, language, student_id, github_url, hosted_url)
    project = Project.new(title, language, student_id, github_url, hosted_url)
    project.save
    project
  end

  def self.for_student(student)
    statement = "Select * from projects where student_id = ?;"
    result = execute_and_instantiate(statement, student.id)
    return nil if result.empty?
    result
  end

  def self.find_by_title(title)
    statement = "Select * from projects where title = ?;"
    execute_and_instantiate(statement, title)[0]
  end

  def self.last
    statement = "Select * from projects order by id DESC limit(1)"
    execute_and_instantiate(statement)[0]
  end

  def destroy
    statement = "Delete from projects where id = ?"
    Environment.database_connection.execute(statement, self.id)
  end

  def save
    if valid?
      statement = "Insert into projects (title, language, student_id, github_url, hosted_url) values (?, ?, ?, ?, ?);"
      Environment.database_connection.execute(statement, [title, language, student_id, github_url, hosted_url])
      @id = Environment.database_connection.execute("SELECT last_insert_rowid();")[0][0]
      true
    else
      false
    end
  end

  def valid?
    @errors = []
    if !title.match /[a-zA-Z]/
      @errors << "'#{self.title}' is not a valid project title, as it does not include any letters."
    elsif Project.find_by_title(self.title)
      @errors << "#{self.title} already exists."
    end
    @errors.empty?
  end

  private

  def self.execute_and_instantiate(statement, bind_vars = [])
    rows = Environment.database_connection.execute(statement, bind_vars)
    results = []
    rows.each do |row|
      project = Project.new(row["title"], row["language"], row["student_id"], row["github_url"], row["hosted_url"])
      project.instance_variable_set(:@id, row["id"])
      results << project
    end
    results
  end
end
