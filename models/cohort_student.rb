class CohortStudent

  def self.create_for(cohort, student)
    statement = "Insert into cohort_students (cohort_id, student_id) values (?, ?);"
    Environment.database_connection.execute(statement, [cohort.id, student.id])
  end

  def self.students_for_cohort(cohort)
    statement = "select student_id from cohort_students where cohort_id = ?;"
    Environment.database_connection.execute(statement, [cohort.id])
    #Student.find_by_id(id)
  end
end
