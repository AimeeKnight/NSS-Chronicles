require_relative '../spec_helper'

describe Student do
  context ".all" do
    context "with no students in the database" do
      it "should return an empty array" do
        Student.all.should == []
      end
    end
    context "with multiple entries in the database" do
        let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
        let(:aimee){ Student.new("Aimee", "Knight", test_cohort_1.id) }
        let(:jamie){ Student.new("Jamie", "Knight", test_cohort_1.id) }
        let(:jay){ Student.new("Jay", "Knight", test_cohort_1.id) }
        let(:bob){ Student.new("Bob", "Knight", test_cohort_1.id) }
      before do
        aimee.save
        jamie.save
        jay.save
        bob.save
      end
      it "should return all the entries in the database with their names and ids" do
        student_attrs = Student.all.map{ |student| [student.first_name, student.id] }
        student_attrs.should == [["Aimee", aimee.id],
                                 ["Jamie", jamie.id],
                                 ["Jay", jay.id],
                                 ["Bob", bob.id]]
      end
    end
  end

  context ".alumni" do
    context "with no students in the database" do
      it "should return an empty array" do
        Student.all.should == []
      end
    end
    context "with multiple alumni in the database" do
      let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
      let(:aimee){ Student.create("Aimee", "Knight", test_cohort_1.id) }
      let(:jamie){ Student.create("Jamie", "Knight", test_cohort_1.id) }
      let(:jay){ Student.create("Jay", "Knight", test_cohort_1.id) }
      before do
        aimee.make_alumni
        jamie.make_alumni
      end
      it "should return 2 students" do
        Student.alumni.length.should == 2
      end
      it "should return only the students who are alumni" do
        Student.alumni[0].alumni?.should == true
      end
      it "should return the last student as an alumni" do
        Student.alumni.last.alumni?.should == true
      end
    end
  end

  context ".count" do
    context "with no students in the database" do
      it "should return 0" do
        Student.count.should == 0
      end
    end
    context "with multiple students in the database" do
      let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
      before do
        Student.new("Aimee", "Knight", test_cohort_1.id).save
        Student.new("Jamie", "Knight", test_cohort_1.id).save
        Student.new("Jay", "Knight", test_cohort_1.id).save
        Student.new("Bob", "Knight", test_cohort_1.id).save
      end
      it "should return the correct count" do
        Student.count.should == 4
      end
    end
  end

  context ".find_by_first_name" do
    context "with no students in the database" do
      it "should return 0" do
        Student.find_by_first_name("Aimee").should be_nil
      end
    end
    context "given a student with the passed first name in the database" do
        let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
        let(:aimee){ Student.new("Aimee", "Knight", test_cohort_1.id) } 
      before do
        aimee.save
        Student.new("Jamie", "Knight", test_cohort_1.id).save
        Student.new("Jay", "Knight", test_cohort_1.id).save
        Student.new("Bob", "Knight", test_cohort_1.id).save
      end
      it "should return the student with that first_name" do
        Student.find_by_first_name("Aimee").first_name.should == "Aimee"
      end
      it "should populate the id" do
        Student.find_by_first_name("Aimee").id.should == aimee.id
      end
    end
  end

  context ".find_by_first_and_last_name" do
    context "with no students in the database" do
      it "should return 0" do
        Student.find_by_first_and_last_name("Aimee", "Knight").should be_nil
      end
    end
    context "given a student with the passed first name in the database" do
        let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
        let(:aimee){ Student.new("Aimee", "Knight", test_cohort_1.id) } 
      before do
        aimee.save
        Student.new("Jamie", "Knight", test_cohort_1.id).save
        Student.new("Jay", "Knight", test_cohort_1.id).save
        Student.new("Bob", "Knight", test_cohort_1.id).save
      end
      it "should return the student with that first_name" do
        Student.find_by_first_and_last_name("Aimee", "Knight").first_name.should == "Aimee"
      end
      it "should return the student with that first_name" do
        Student.find_by_first_and_last_name("Aimee", "Knight").last_name.should == "Knight"
      end
      it "should populate the id" do
        Student.find_by_first_and_last_name("Aimee", "Knight").id.should == aimee.id
      end
    end
  end

  context ".for_cohort" do
    context "with no student in the database" do
      let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
      it "should not return any students" do
        Student.for_cohort(test_cohort_1).should == nil
      end
    end
    context "with multiple students in the database" do
      let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
      let(:test_cohort_2){ Cohort.create("Test Cohort 2", "JS/Ruby", "Spring 14") }
      let!(:aimee){ Student.create("Aimee", "Knight", test_cohort_1.id) }
      let!(:jamie){ Student.create("Jamie", "Knight", test_cohort_1.id) }
      let!(:jay){ Student.create("Jay", "Knight", test_cohort_1.id) }
      let!(:bob){ Student.create("Bob", "Knight", test_cohort_2.id) }
      it "should return 4 students" do
        Student.for_cohort(test_cohort_1).length.should == 3
      end
      it "the should return students from the cohort that was passed in" do
        Student.for_cohort(test_cohort_1)[0].cohort_id.should == test_cohort_1.id
      end
    end
  end

  context ".projects_from_cohort" do
    context "with multiple project in the database" do
      let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
      let(:aimee){ Student.create("Aimee", "Knight", test_cohort_1.id) }
      let!(:test_project_1){ Project.create("Test Project 1", "Ruby", aimee.id, "www.github.com/example", "www.example.com") }
      let!(:test_project_2){ Project.create("Test Project 2", "Ruby", aimee.id, "www.github.com/example", "www.example.com") }
      let!(:test_project_3){ Project.create("Test Project 3", "Ruby", aimee.id, "www.github.com/example", "www.example.com") }
      it "should return 3 projects" do
        Student.projects_from_cohort(test_cohort_1).length.should == 3
      end
      it "should the first name for a student who worked on a project in the cohort" do
        Student.projects_from_cohort(test_cohort_1)[0]["first_name"].should == aimee.first_name
      end
      it "should the last name for a student who worked on a project in the cohort" do
        Student.projects_from_cohort(test_cohort_1)[0]["last_name"].should == aimee.last_name
      end
      it "should return a title for the projects in the cohort" do
        Student.projects_from_cohort(test_cohort_1)[0]["title"].should == test_project_1.title
      end
    end
  end

  context ".last" do
    context "with no students in the database" do
      it "should return nil" do
        Student.last.should be_nil
      end
    end
    context "with multiple students in the database" do
      let(:test_cohort_2){ Cohort.create("Test Cohort 2", "JS/Ruby", "Summer 14") }
      let(:bob){ Student.new("Bob", "Knight", test_cohort_2.id) }
      before do
        Student.new("Aimee", "Knight", test_cohort_2.id).save
        Student.new("Jamie", "Knight", test_cohort_2.id).save
        Student.new("Jay", "Knight", test_cohort_2.id).save
        bob.save
      end
      it "should return the last student inserted" do
        Student.last.first_name.should == "Bob"
      end
      it "should return the last student inserted with the id populated" do
        Student.last.id.should == bob.id
      end
    end
  end

  context "#alumni?" do
    context "the default value when adding a student" do
      let(:result){ Environment.database_connection.execute("Select * from students where id = #{student.id}") }
      let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Summer 14") }
      let(:student){ Student.create("Aimee", "Knight", test_cohort_1.id) }
      it "a student's default alumni status should be false" do
        student.alumni?.should == false
      end
      it "the students status in the database she also default to false" do
        result[0]["alumni"].should == 0
      end
    end
  end

  context "#make_alumni" do
    let(:result){ Environment.database_connection.execute("Select * from students where id = #{student.id}") }
    let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Summer 14") }
    let(:student){ Student.create("Aimee", "Knight", test_cohort_1.id) }
    before do
      student.make_alumni
    end
    it "should set the student's alumni status" do
      student.alumni?.should == true
    end
    it "should update the students status in the database" do
      result[0]["alumni"].should == 1
    end
  end

  context "#new" do
    let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Summer 14") }
    let(:student){ Student.new("Aimee", "Knight", test_cohort_1) }
    it "should store the first_name" do
      student.first_name.should == "Aimee"
    end
  end

  context "#create" do
    let(:result){ Environment.database_connection.execute("Select * from students") }
    let(:test_cohort_2){ Cohort.create("Test Cohort 2", "JS/Ruby", "Summer 14") }
    let(:student){ Student.create("Aimee", "Knight", test_cohort_2.id) }
    context "with a valid student" do
      before do
       Student.any_instance.stub(:valid?){ true }
       student
      end
      it "should record the new id" do
        result[0]["id"].should == student.id
      end
      it "should only save one row to the database" do
        result.count.should == 1
      end
      it "should actually save it to the database" do
        result[0]["first_name"].should == "Aimee"
      end
    end
    context "with an invalid student" do
      before do
        Student.any_instance.stub(:valid?){ false }
        student
      end
      it "should not save the student to the database" do
        result.count.should == 0
      end
    end
  end

  context "#delete" do
    let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Summer 14") }
    context "with only one student in the database" do
      let(:student){ Student.create("Aimee", "Knight", test_cohort_1.id) }
      before do
        student.destroy
      end
      it "should delete the student from the database" do
        Student.count.should == 0
      end
    end
    context "with multiple students in the database" do
      let(:aimee){ Student.create("Aimee", "Knight", test_cohort_1.id) }
      let!(:jamie){ Student.create("Jamie", "Knight", test_cohort_1.id) }
      let!(:jay){ Student.create("Jay", "Knight", test_cohort_1.id) }
      before do
        aimee.destroy
      end
      it "should only delete one student from the database" do
        Student.count.should == 2
      end
    end
  end

  context "#projects" do
    let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Summer 14") }
    let(:student){ Student.create("Aimee", "Knight", test_cohort_1.id) }
    context "delegate to projects" do
      it "should delegate to the Project" do
        expect(Project).to receive(:for_student)
        student.projects
      end
    end
  end

  context "#save" do
    let(:result){ Environment.database_connection.execute("Select first_name from students") }
    let(:test_cohort_2){ Cohort.create("Test Cohort 2", "JS/Ruby", "Summer 14") }
    let(:student){ Student.new("Foo", "Knight", test_cohort_2.id) }
    context "with a valid student" do
      before do
        student.stub(:valid?) { true }
      end
      it "should only save one row to the database" do
        student.save
        result.count.should == 1
      end
      it "should actually save it to the database" do
        student.save
        result[0]["first_name"].should == "Foo"
      end
    end
    context "with an invalid student" do
      before do
        student.stub(:valid?) { false }
      end
      it "should not save a new student to the database" do
        student.save
        result.count.should == 0
      end
    end
  end

  context "#valid?" do
    let(:result){ Environment.database_connection.execute("Select first_name from students") }
    context "after fixing the errors" do
      let(:test_cohort_2){ Cohort.create("Test Cohort 2", "JS/Ruby", "Summer 14") }
      let(:student){ Student.new("123", "Knight", test_cohort_2.id) }
      it "should return true" do
        student.valid?.should be_false
        student.first_name = "Bar"
        student.valid?.should be_true
      end
    end
    context "with a unique first_name" do
      let(:student){ Student.new("Aimee", "Knight", "4") }
      it "should return true" do
        student.valid?.should be_true
      end
    end
    context "with an invalid first_name" do
      let(:student){ Student.new("123", "Knight", "4") }
      it "should return false" do
        student.valid?.should be_false
      end
      it "should save the error messages" do
        student.valid?
        student.errors.first.should == "'123' is not a valid student first name, as it does not include any letters."
      end
    end
    context "with a duplicate first_name" do
      let(:student){ Student.new("Aimee", "Knight", "4") }
      before do
        Student.new("Aimee", "Knight", "4").save
      end
      it "should return false" do
        student.valid?.should be_false
      end
      it "should save the error messages" do
        student.valid?
        student.errors.first.should == "Aimee already exists."
      end
    end
  end

  context "#to_s" do
    let(:test_cohort_2){ Cohort.create("Test Cohort 2", "JS/Ruby", "Summer 14") }
    let(:student) { Student.create("Aimee", "Knight", test_cohort_2.id) }
    it "converts to a string with properties" do
      expect(student.to_s).to eq "ID: #{student.id}, FIRST NAME: Aimee, LAST NAME: Knight, COHORT ID: #{test_cohort_2.id}, ALUMNI: false"
    end
  end

  context ".join_to_s" do
    let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Summer 14") }
    let(:student) { Student.create("Aimee", "Knight", test_cohort_1.id) }
    let!(:test_project_1){ Project.create("Test Project 1", "Ruby", student.id, "www.github.com/example", "www.example.com") }
    let (:result) { Student.projects_from_cohort(test_cohort_1) }
    it "converts the returned database rows to strings" do
      expect(Student.join_to_s(result[0])).to eq "TITLE: #{test_project_1.title}, LANGUAGE: #{test_project_1.language}, STUDENT NAME: #{student.first_name} #{student.last_name}"
    end
  end

end
