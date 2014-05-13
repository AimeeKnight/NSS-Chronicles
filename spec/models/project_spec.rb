require_relative '../spec_helper'

describe Project do
  context ".all" do
    context "with no projects in the database" do
      it "should return an empty array" do
        Project.all.should == []
      end
    end
    context "with multiple entries in the database" do
        let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
        let(:aimee){ Student.new(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
        let(:jamie){ Student.new(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id) }
        let(:test_project_1){ Project.new(title: "Test Project 1", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
        let(:test_project_2){ Project.new(title: "Test Project 2", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
        let(:test_project_3){ Project.new(title: "Test Project 3", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
        let(:test_project_4){ Project.new(title: "Test Project 4", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
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
      let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
      let(:aimee){ Student.new(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let(:jamie){ Student.new(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id) }
      before do
        Project.new(title: "Test Project 1", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com").save
        Project.new(title: "Test Project 2", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com").save
        Project.new(title: "Test Project 3", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com").save
        Project.new(title: "Test Project 4", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com").save
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
      let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
      let(:aimee){ Student.new(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let(:jamie){ Student.new(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let(:test_project_1){ Project.new(title: "Test Project 1", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      before do
        test_project_1.save
        Project.new(title: "Test Project 2", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com").save
        Project.new(title: "Test Project 3", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com").save
        Project.new(title: "Test Project 4", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com").save
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
      let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
      let(:aimee){ Student.create(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let(:test_project_1){ Project.create(title: "Test Project 1", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      it "should not return any projects" do
        aimee.projects[0].should == nil
      end
    end
    context "with multiple projects in the database" do
      let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
      let(:aimee){ Student.create(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let(:jamie){ Student.create(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let!(:test_project_1){ Project.create(title: "Test Project 1", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      let!(:test_project_2){ Project.create(title: "Test Project 2", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      let!(:test_project_3){ Project.create(title: "Test Project 3", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      let!(:test_project_4){ Project.create(title: "Test Project 4", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      it "should return 2 projects" do
        aimee.projects.length.should == 2
      end
      it "the should return the correct project title for the students first project" do
        aimee.projects[0].title.should == "Test Project 1"
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
      let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
      let(:aimee){ Student.new(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let(:jamie){ Student.new(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id) }
      let(:test_project_4){ Project.create(title: "Test Project 4", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      before do
        Project.new(title: "Test Project 1", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com").save
        Project.new(title: "Test Project 2", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com").save
        Project.new(title: "Test Project 3", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com").save
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
    let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
    let(:aimee){ Student.new(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
    let(:project){ Project.create(title: "Test Project 1", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
    it "should store the title" do
      project.title.should == "Test Project 1"
    end
  end

  context "#create" do
    let(:result){ Project.connection.execute("Select * from projects") }
    let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
    let(:jamie){ Student.new(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id) }
    let(:project){ Project.create(title: "Test Project Foo", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
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

  context "#delete" do
    let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
    let(:aimee){ Student.new(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
    let(:test_project_1){ Project.create(title: "Test Project 1", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
    context "with only one project in the database" do
      before do
        test_project_1.destroy
      end
      it "should delete the project from the database" do
        Project.count.should == 0
      end
    end
    context "with multiple projects in the database" do
      let!(:test_project_1){ Project.create(title: "Test Project 1", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      let!(:test_project_2){ Project.create(title: "Test Project 2", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      let!(:test_project_3){ Project.create(title: "Test Project 3", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      before do
        test_project_1.destroy
      end
      it "should only delete one project from the database" do
        Project.count.should == 2
      end
    end
  end

  context "#save" do
    let(:result){ Project.connection.execute("Select title from projects") }
    let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
    let(:jamie){ Student.new(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id) }
    let(:project){ Project.create(title: "Test Project Foo", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
    context "with a valid project" do
      before do
        Project.any_instance.stub(:valid?) { true }
        project
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
        Project.any_instance.stub(:valid?) { false }
        project
      end
      it "should not save a new project to the database" do
        project.save
        result.count.should == 0
      end
    end
  end

  context "#valid?" do
    let(:result){ Environment.database_connection.execute("Select title from projects") }
    let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
    let(:jamie){ Student.new(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id) }
    context "after fixing the errors" do
      let(:project){ Project.create(title: "123", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      it "should return true" do
        project.valid?.should be_false
        project.title = "Test Project Bar"
        project.valid?.should be_true
      end
    end
    context "with a unique title" do
      let(:project){ Project.create(title: "Test Project 1", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      it "should return true" do
        project.valid?.should be_true
      end
    end
    context "with an invalid title" do
      let(:project){ Project.create(title: "123", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      it "should return false" do
        project.valid?.should be_false
      end
      it "should save the error messages" do
        project.valid?
        project.errors[:title].first.should == "is not a valid project title, as it does not include any letters."
      end
    end
    context "with a duplicate title" do
      let(:project){ Project.create(title: "Test Project 1", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
      before do
        Project.new(title: "Test Project 1", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com").save
      end
      it "should return false" do
        project.valid?.should be_false
      end
      it "should save the error messages" do
        project.valid?
        project.errors[:title].first.should == "already exists."
      end
    end
  end

  context "#to_s" do
    let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
    let(:jamie){ Student.create(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id) }
    let(:project){ Project.create(title: "Test Project 1", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
    it "converts to a string with properties" do
      expect(project.to_s).to eq "ID: #{project.id}, TITLE: Test Project 1, LANGUAGE: Ruby, STUDENT ID: #{jamie.id}, GITHUB URL: www.github.com/example, HOSTED URL: www.example.com"
    end
  end

  context ".for_cohort" do
    let(:test_cohort_1){ Cohort.create(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14") }
    let(:aimee){ Student.create(first_name: "Aimee", last_name: "Knight", cohort_id: test_cohort_1.id) }
    let(:jamie){ Student.create(first_name: "Jamie", last_name: "Knight", cohort_id: test_cohort_1.id) }
    let!(:test_project_1){ Project.create(title: "Test Project 1", language: "Ruby", student_id: aimee.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
    let!(:test_project_2){ Project.create(title: "Test Project 2", language: "Ruby", student_id: jamie.id, github_url: "www.github.com/example", hosted_url: "www.example.com") }
    it "should return 2 projects" do
      test_cohort_1.projects.length.should == 2
    end
  end

end
