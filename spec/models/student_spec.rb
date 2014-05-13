require_relative '../spec_helper'

describe Student do
  context ".all" do
    context "with no students in the database" do
      it "should return an empty array" do
        Student.all.should == []
      end
    end
    context "with multiple entries in the database" do
        let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
        let(:aimee){ Student.new(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
        let(:jamie){ Student.new(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id) }
        let(:jay){ Student.new(first_name: "Jay", last_name: "Knight", cohort_id: test_cohort_1.id) }
        let(:bob){ Student.new(first_name: "Bob", last_name: "Knight", cohort_id: test_cohort_1.id) }
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
      let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
      let(:aimee){ Student.create(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let(:jamie){ Student.create(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let(:jay){ Student.create(first_name: "Jay", last_name: "Knight", cohort_id: test_cohort_1.id) }
      before do
        aimee.make_alumni
        jamie.make_alumni
      end
      it "should return 2 students" do
        Student.alumni.length.should == 2
      end
      it "should return only the students who are alumni" do
        Student.alumni[0].alumni.should == true
      end
      it "should return the last student as an alumni" do
        Student.alumni.last.alumni.should == true
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
      let(:test_cohort_1){ Cohort.create({ title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14" }) }
      before do
        Student.new(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id).save
        Student.new(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id).save
        Student.new(first_name: "Jay", last_name: "Knight", cohort_id: test_cohort_1.id).save
        Student.new(first_name: "Bob", last_name: "Knight", cohort_id: test_cohort_1.id).save
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
        let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
        let(:aimee){ Student.new(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) } 
      before do
        aimee.save
        Student.new(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id).save
        Student.new(first_name: "Jay", last_name: "Knight", cohort_id: test_cohort_1.id).save
        Student.new(first_name: "Bob", last_name: "Knight", cohort_id: test_cohort_1.id).save
      end
      it "should return the student with that first_name" do
        Student.find_by_first_name("Aimee").first_name.should == aimee.first_name
      end
      it "should populate the id" do
        Student.find_by_first_name("Aimee").id.should == aimee.id
      end
    end
  end

  context ".find_by_first_and_last_name" do
    context "with no students in the database" do
      it "should return 0" do
        Student.find_by_first_and_last_name("Aimee", "Knight")[0].should be_nil
      end
    end
    context "given a student with the passed first name in the database" do
        let(:test_cohort_1){ Cohort.create({ title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14" }) }
        let(:aimee){ Student.new(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
      before do
        aimee.save
        Student.new(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id).save
        Student.new(first_name: "Jay", last_name: "Knight", cohort_id: test_cohort_1.id).save
        Student.new(first_name: "Bob", last_name: "Knight", cohort_id: test_cohort_1.id).save
      end
      it "should return the student with that first_name" do
        Student.find_by_first_and_last_name("Aimee", "Knight")[0][:first_name].should == "Aimee"
      end
      it "should return the student with that first_name" do
        Student.find_by_first_and_last_name("Aimee", "Knight")[0][:last_name].should == "Knight"
      end
      it "should populate the id" do
        Student.find_by_first_and_last_name("Aimee", "Knight")[0][:id].should == aimee.id
      end
    end
  end

  context ".for_cohort" do
    context "with no student in the database" do
      let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
      it "should not return any students" do
        test_cohort_1.students[0].should == nil
      end
    end
    context "with multiple students in the database" do
      let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
      let(:test_cohort_2){ Cohort.create(title: "Test Cohort 2", languages: "JS/Ruby", term: "Spring 14") }
      let!(:aimee){ Student.create(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let!(:jamie){ Student.create(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let!(:jay){ Student.create(first_name: "Jay", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let!(:bob){ Student.create(first_name: "Bob", last_name: "Knight", cohort_id: test_cohort_2.id) }
      it "should return 3 students" do
        test_cohort_1.students.length.should == 3
      end
      it "the should return students from the cohort that was passed in" do
        test_cohort_1.students[0].first_name.should == "Aimee"
      end
    end
  end

  context ".projects_from_cohort" do
    context "with multiple project in the database" do
      let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
      let(:aimee){ Student.create(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let!(:test_project_1){ Project.create(title: "Test Project 1", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      let!(:test_project_2){ Project.create(title: "Test Project 2", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      let!(:test_project_3){ Project.create(title: "Test Project 3", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      it "should return 3 projects" do
        test_cohort_1.projects.length.should == 3
      end
      it "should return the first name for a student who worked on a project in the cohort" do
        test_cohort_1.projects[0].student.first_name.should == aimee.first_name
      end
      it "should the last name for a student who worked on a project in the cohort" do
        test_cohort_1.projects[0].student.last_name.should == aimee.last_name
      end
      it "should return a title for the projects in the cohort" do
        test_cohort_1.projects[0].title.should == "Test Project 1"
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
      let(:test_cohort_2){ Cohort.create!(title: "Test Cohort 2", languages: "JS/Ruby", term: "Spring 14") }
      let(:bob){ Student.new(first_name: "Bob", last_name: "Knight", cohort_id: test_cohort_2.id) }
      before do
        Student.new(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_2.id).save
        Student.new(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_2.id).save
        Student.new(first_name: "Jay", last_name: "Knight", cohort_id: test_cohort_2.id).save
        bob.save!
      end
      it "should return the last student inserted" do
        Student.last.first_name.should == bob.first_name
      end
      it "should return the last student inserted with the id populated" do
        Student.last.id.should == bob.id
      end
    end
  end

  context "#alumni?" do
    context "the default value when adding a student" do
      let(:result){ Student.connection.execute("Select * from students where id = #{student.id}") }
      let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
      let(:student){ Student.create(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
      it "a student's default alumni status should be false" do
        student.alumni?.should == false
      end
      it "the students status in the database she also default to false" do
        result[0]["alumni"].should == 'f'
      end
    end
  end

  context "#make_alumni" do
    let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
    let(:student){ Student.create(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
    let(:result){ Student.connection.execute("Select * from students where id = #{student.id}") }
    before do
      student.make_alumni
    end
    it "should set the student's alumni status" do
      student.alumni?.should == true
    end
    it "should update the students status in the database" do
      result[0]["alumni"].should == 't'
    end
  end

  context "#new" do
    let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
    let(:student){ Student.new(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1) }
    it "should store the first_name" do
      student.first_name.should == "Aimee"
    end
  end

  context "#create" do
    let(:result){ Student.connection.execute("Select * from students") }
    let(:test_cohort_2){ Cohort.create(title: "Test Cohort 2", languages: "JS/Ruby", term: "Spring 14") }
    let(:student){ Student.create(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_2.id) }
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
        result[0]["first_name"].should == student.first_name
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
    let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
    context "with only one student in the database" do
      let(:student){ Student.create(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
      before do
        student.destroy
      end
      it "should delete the student from the database" do
        Student.count.should == 0
      end
    end
    context "with multiple students in the database" do
      let(:aimee){ Student.create(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let!(:jamie){ Student.create(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let!(:jay){ Student.create(first_name: "Jay", last_name: "Knight", cohort_id: test_cohort_1.id) }
      before do
        aimee.destroy
      end
      it "should only delete one student from the database" do
        Student.count.should == 2
      end
    end
  end

  context "#save" do
    let(:result){ Student.connection.execute("Select first_name from students") }
    let(:test_cohort_2){ Cohort.create(title: "Test Cohort 2", languages: "JS/Ruby", term: "Spring 14") }
    let(:student){ Student.new(first_name: "Foo", last_name: "Knight", cohort_id: test_cohort_2.id) }
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
      let(:test_cohort_2){ Cohort.create(title: "Test Cohort 2", languages: "JS/Ruby", term: "Spring 14") }
      let(:student){ Student.new(first_name: "123", last_name: "Knight", cohort_id: test_cohort_2.id) }
      it "should return true" do
        student.valid?.should be_false
        student.first_name = "Bar"
        student.valid?.should be_true
      end
    end
    context "with a unique first_name" do
      let(:student){ Student.new(first_name: "Aimee", last_name: "Knight", cohort_id: 4) }
      it "should return true" do
        student.valid?.should be_true
      end
    end
    context "with an invalid first_name" do
      let(:student){ Student.new(first_name: "123", last_name: "Knight", cohort_id: 4) }
      it "should return false" do
        student.valid?.should be_false
      end
      it "should save the error messages" do
        student.valid?
        student.errors[:first_name].first.should == "is not a valid student first name, as it does not include any letters."
      end
    end
    context "with a duplicate first_name" do
      let(:student){ Student.create(first_name: "Aimee", last_name: "Knight", cohort_id: 4) }
      before do
        Student.create(first_name: "Aimee", last_name:"Knight", cohort_id: 4)
      end
      it "should return false" do
        student.valid?.should be_false
      end
      it "should save the error messages" do
        student.valid?
        student.errors[:first_name].first.should == "already exists."
      end
    end
  end

  context "#to_s" do
    let(:test_cohort_2){ Cohort.create(title: "Test Cohort 2", languages: "JS/Ruby", term: "Spring 14") }
    let(:student) { Student.create(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_2.id) }
    it "converts to a string with properties" do
      expect(student.to_s).to eq "ID: #{student.id}, FIRST NAME: Aimee, LAST NAME: Knight, COHORT ID: #{test_cohort_2.id}, ALUMNI: false"
    end
  end

end
