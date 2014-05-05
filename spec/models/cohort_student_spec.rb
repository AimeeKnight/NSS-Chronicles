require_relative '../spec_helper'

describe CohortStudent do
  context "#create_for" do
    let(:result){ Environment.database_connection.execute("Select * from cohort_students") }
    let(:cohort){ Cohort.new("Test Cohort 1", "JS/Ruby", "Spring 14") }
    let(:student){ Student.new("Aimee", "Knight", "4") }
    before do
      cohort.save
      student.save
      CohortStudent.create_for(cohort, student)
    end
    it "should save a new cohort_student to the database" do
      result.count.should == 1
    end
    it "should save the foreign key for cohort" do
      result[0]["cohort_id"].should == cohort.id
    end
    it "should save the foreign key for student" do
      result[0]["student_id"].should == student.id
    end
  end

  context "#students_for_cohort" do
    let(:result){ Environment.database_connection.execute("Select * from cohort_students") }
    let(:cohort){ Cohort.new("Test Cohort 1", "JS/Ruby", "Spring 14") }
    let(:student){ Student.new("Aimee", "Knight", "4") }
    before do
      cohort.save
      student.save
      CohortStudent.create_for(cohort, student)
      CohortStudent.students_for_cohort(cohort)
    end
    it "should return the one student we have in the table" do
      result.count.should == 1
    end
  end
end
