class Student
  attr_accessor :first_name,
                :last_name,
                :cohort_id

  def initialize(first_name, last_name, cohort_id)
    self.first_name = first_name
    self.last_name = last_name
    self.cohort_id = cohort_id
  end

  def to_s
    "First Name: #{first_name}, Last Name: #{last_name}, Cohort Id: #{cohort_id}"
  end

end
