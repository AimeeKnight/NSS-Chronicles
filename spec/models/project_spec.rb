require_relative '../spec_helper'

describe Project do
  context ".all" do
    context "with no projects in the database" do
      it "should return an empty array" do
        Project.all.should == []
      end
    end
    context "with multiple entries in the database" do
        let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
        let(:aimee){ Student.new("Aimee", "Knight", test_cohort_1.id) }
        let(:jamie){ Student.new("Jamie", "Knight", test_cohort_1.id) }
        let(:test_project_1){ Project.new("Test Project 1", "Ruby", aimee.id, "www.github.com/example", "www.example.com") }
        let(:test_project_2){ Project.new("Test Project 2", "Ruby", aimee.id, "www.github.com/example", "www.example.com") }
        let(:test_project_3){ Project.new("Test Project 3", "Ruby", jamie.id, "www.github.com/example", "www.example.com") }
        let(:test_project_4){ Project.new("Test Project 4", "Ruby", jamie.id, "www.github.com/example", "www.example.com") }
      before do
        test_project_1.save
        test_project_2.save
        test_project_3.save
        test_project_4.save
      end
      it "should return all the entries in the database" do
        project_attrs = Project.all.map{ |project| [project.title, project.id] }
        project_attrs.should == [["Test Project 1", test_project_1.id],
                                 ["Test Project 2", test_project_2.id],
                                 ["Test Project 3", test_project_3.id],
                                 ["Test Project 4", test_project_4.id]]
      end
    end
  end

  context ".count" do
    context "with no projects in the database" do
      it "should return 0" do
        Project.count.should == 0
      end
    end
    context "with multiple projects in the database" do
      let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
      let(:aimee){ Student.new("Aimee", "Knight", test_cohort_1.id) }
      let(:jamie){ Student.new("Jamie", "Knight", test_cohort_1.id) }
      before do
        Project.new("Test Project 1", "Ruby", aimee.id, "www.github.com/example", "www.example.com").save
        Project.new("Test Project 2", "Ruby", aimee.id, "www.github.com/example", "www.example.com").save
        Project.new("Test Project 3", "Ruby", jamie.id, "www.github.com/example", "www.example.com").save
        Project.new("Test Project 4", "Ruby", jamie.id, "www.github.com/example", "www.example.com").save
      end
      it "should return the correct count" do
        Project.count.should == 4
      end
    end
  end

  context ".find_by_title" do
    context "with no projects in the database" do
      it "should return 0" do
        Project.find_by_title("Test Project 1").should be_nil
      end
    end
    context "given a project with the passed title in the database" do
      let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
      let(:aimee){ Student.new("Aimee", "Knight", test_cohort_1.id) }
      let(:jamie){ Student.new("Jamie", "Knight", test_cohort_1.id) }
      let(:test_project_1){ Project.new("Test Project 1", "Ruby", aimee.id, "www.github.com/example", "www.example.com") }
      before do
        test_project_1.save
        Project.new("Test Project 2", "Ruby", jamie.id, "www.github.com/example", "www.example.com").save
        Project.new("Test Project 3", "Ruby", aimee.id, "www.github.com/example", "www.example.com").save
        Project.new("Test Project 4", "Ruby", jamie.id, "www.github.com/example", "www.example.com").save
      end
      it "should return the project with that title" do
        Project.find_by_title("Test Project 1").title.should == "Test Project 1"
      end
      it "should populate the id" do
        Project.find_by_title("Test Project 1").id.should == test_project_1.id
      end
    end
  end

  context ".for_student" do
    context "without projects in the database" do
      let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
      let(:aimee){ Student.create("Aimee", "Knight", test_cohort_1.id) }
      it "should not return any projects" do
        Project.for_student(aimee).should == nil
      end
    end
    context "with multiple projects in the database" do
      let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
      let(:aimee){ Student.create("Aimee", "Knight", test_cohort_1.id) }
      let(:jamie){ Student.create("Jamie", "Knight", test_cohort_1.id) }
      let!(:test_project_1){ Project.create("Test Project 1", "Ruby", aimee.id, "www.github.com/example", "www.example.com") }
      let!(:test_project_2){ Project.create("Test Project 2", "Ruby", aimee.id, "www.github.com/example", "www.example.com") }
      let!(:test_project_3){ Project.create("Test Project 3", "Ruby", jamie.id, "www.github.com/example", "www.example.com") }
      let!(:test_project_4){ Project.create("Test Project 4", "Ruby", jamie.id, "www.github.com/example", "www.example.com") }
      it "should return 2 projects" do
        Project.for_student(aimee).length.should == 2
      end
      it "the should return projects for the student that was passed in" do
        Project.for_student(aimee)[0]["student_id"].should == aimee.id
      end
    end
  end

  context ".last" do
    context "with no projects in the database" do
      it "should return nil" do
        Project.last.should be_nil
      end
    end
    context "with multiple projects in the database" do
      let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
      let(:aimee){ Student.new("Aimee", "Knight", test_cohort_1.id) }
      let(:jamie){ Student.new("Jamie", "Knight", test_cohort_1.id) }
      let(:test_project_4){ Project.new("Test Project 4", "Ruby", jamie.id, "www.github.com/example", "www.example.com") }
      before do
        Project.new("Test Project 1", "Ruby", jamie.id, "www.github.com/example", "www.example.com").save
        Project.new("Test Project 2", "Ruby", aimee.id, "www.github.com/example", "www.example.com").save
        Project.new("Test Project 3", "Ruby", aimee.id, "www.github.com/example", "www.example.com").save
        test_project_4.save
      end
      it "should return the last project inserted" do
        Project.last.title.should == "Test Project 4"
      end
      it "should return the last project inserted with the id populated" do
        Project.last.id.should == test_project_4.id
      end
    end
  end

  context "#new" do
    let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
    let(:aimee){ Student.new("Aimee", "Knight", test_cohort_1.id) }
    let(:project){ Project.new("Test Project 1", "Ruby", aimee.id, "www.github.com/example", "www.example.com") }
    it "should store the title" do
      project.title.should == "Test Project 1"
    end
  end

  context "#create" do
    let(:result){ Environment.database_connection.execute("Select * from projects") }
    let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
    let(:jamie){ Student.new("Jamie", "Knight", test_cohort_1.id) }
    let(:project){ Project.create("Test Project Foo", "Ruby", jamie.id, "www.github.com/example", "www.example.com") }
    context "with a valid project" do
      before do
       Project.any_instance.stub(:valid?){ true }
       project
      end
      it "should record the new id" do
        result[0]["id"].should == project.id
      end
      it "should only save one row to the database" do
        result.count.should == 1
      end
      it "should actually save it to the database" do
        result[0]["title"].should == "Test Project Foo"
      end
    end
    context "with an invalid project" do
      before do
        Project.any_instance.stub(:valid?){ false }
        project
      end
      it "should not save the project to the database" do
        result.count.should == 0
      end
    end
  end

  context "#save" do
    let(:result){ Environment.database_connection.execute("Select title from projects") }
    let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
    let(:jamie){ Student.new("Jamie", "Knight", test_cohort_1.id) }
    let(:project){ Project.new("Test Project Foo", "Ruby", jamie.id, "www.github.com/example", "www.example.com") }
    context "with a valid project" do
      before do
        project.stub(:valid?) { true }
      end
      it "should only save one row to the database" do
        project.save
        result.count.should == 1
      end
      it "should actually save it to the database" do
        project.save
        result[0]["title"].should == "Test Project Foo"
      end
    end
    context "with an invalid project" do
      before do
        project.stub(:valid?) { false }
      end
      it "should not save a new project to the database" do
        project.save
        result.count.should == 0
      end
    end
  end

  context "#valid?" do
    let(:result){ Environment.database_connection.execute("Select title from projects") }
    let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
    let(:jamie){ Student.new("Jamie", "Knight", test_cohort_1.id) }
    context "after fixing the errors" do
      let(:project){ Project.new("123", "Ruby", jamie.id, "www.github.com/example", "www.example.com") }
      it "should return true" do
        project.valid?.should be_false
        project.title = "Test Project Bar"
        project.valid?.should be_true
      end
    end
    context "with a unique title" do
      let(:project){ Project.new("Test Project 1", "Ruby", jamie.id, "www.github.com/example", "www.example.com") }
      it "should return true" do
        project.valid?.should be_true
      end
    end
    context "with an invalid title" do
      let(:project){ Project.new("123", "Ruby", jamie.id, "www.github.com/example", "www.example.com") }
      it "should return false" do
        project.valid?.should be_false
      end
      it "should save the error messages" do
        project.valid?
        project.errors.first.should == "'123' is not a valid project title, as it does not include any letters."
      end
    end
    context "with a duplicate title" do
      let(:project){ Project.new("Test Project 1", "Ruby", jamie.id, "www.github.com/example", "www.example.com") }
      before do
        Project.new("Test Project 1", "Ruby", jamie.id, "www.github.com/example", "www.example.com").save
      end
      it "should return false" do
        project.valid?.should be_false
      end
      it "should save the error messages" do
        project.valid?
        project.errors.first.should == "Test Project 1 already exists."
      end
    end
  end

  context "#to_s" do
    let(:test_cohort_1){ Cohort.create("Test Cohort 1", "JS/Ruby", "Spring 14") }
    let(:jamie){ Student.new("Jamie", "Knight", test_cohort_1.id) }
    let(:project) { Project.new("Test Title 1", "Ruby", jamie.id, "www.github.com/example", "www.example.com") }
    it "converts to a string with properties" do
      expect(project.to_s).to eq "Title: Test Title 1, Language: Ruby, Student Id: #{jamie.id}, GitHub URL: www.github.com/example, Hosted URL: www.example.com"
    end
  end

end
