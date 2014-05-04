require_relative '../spec_helper'

describe Project do
  context ".all" do
    context "with no projects in the database" do
      it "should return an empty array" do
        Project.all.should == []
      end
    end
    context "with multiple entries in the database" do
        let(:test_project_1){ Project.new("Test Project 1", "Ruby", "1", "www.github.com/example", "www.example.com") }
        let(:test_project_2){ Project.new("Test Project 2", "Ruby", "1", "www.github.com/example", "www.example.com") }
        let(:test_project_3){ Project.new("Test Project 3", "Ruby", "1", "www.github.com/example", "www.example.com") }
        let(:test_project_4){ Project.new("Test Project 4", "Ruby", "1", "www.github.com/example", "www.example.com") }
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
      before do
        Project.new("Test Project 1", "Ruby", "1", "www.github.com/example", "www.example.com").save
        Project.new("Test Project 2", "Ruby", "1", "www.github.com/example", "www.example.com").save
        Project.new("Test Project 3", "Ruby", "1", "www.github.com/example", "www.example.com").save
        Project.new("Test Project 4", "Ruby", "1", "www.github.com/example", "www.example.com").save
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
        let(:test_project_1){ Project.new("Test Project 1", "Ruby", "1", "www.github.com/example", "www.example.com") }
      before do
        test_project_1.save
        Project.new("Test Project 2", "Ruby", "1", "www.github.com/example", "www.example.com").save
        Project.new("Test Project 3", "Ruby", "1", "www.github.com/example", "www.example.com").save
        Project.new("Test Project 4", "Ruby", "1", "www.github.com/example", "www.example.com").save
      end
      it "should return the project with that title" do
        Project.find_by_title("Test Project 1").title.should == "Test Project 1"
      end
      it "should populate the id" do
        Project.find_by_title("Test Project 1").id.should == test_project_1.id
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
        let(:test_project_4){ Project.new("Test Project 4", "Ruby", "1", "www.github.com/example", "www.example.com") }
      before do
        Project.new("Test Project 1", "Ruby", "1", "www.github.com/example", "www.example.com").save
        Project.new("Test Project 2", "Ruby", "1", "www.github.com/example", "www.example.com").save
        Project.new("Test Project 3", "Ruby", "1", "www.github.com/example", "www.example.com").save
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
    let(:project){ Project.new("Test Project 1", "Ruby", "1", "www.github.com/example", "www.example.com") }
    it "should store the title" do
      project.title.should == "Test Project 1"
    end
  end

  context "#create" do
    let(:result){ Environment.database_connection.execute("Select * from projects") }
    let(:project){ Project.create("Test Project Foo", "Ruby", "1", "www.github.com/example", "www.example.com") }
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
    let(:project){ Project.new("Test Project Foo", "Ruby", "1", "www.github.com/example", "www.example.com") }
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
    context "after fixing the errors" do
      let(:project){ Project.new("123", "Ruby", "1", "www.github.com/example", "www.example.com") }
      it "should return true" do
        project.valid?.should be_false
        project.title = "Test Project Bar"
        project.valid?.should be_true
      end
    end
    context "with a unique title" do
      let(:project){ Project.new("Test Project 1", "Ruby", "1", "www.github.com/example", "www.example.com") }
      it "should return true" do
        project.valid?.should be_true
      end
    end
    context "with an invalid title" do
      let(:project){ Project.new("123", "Ruby", "1", "www.github.com/example", "www.example.com") }
      it "should return false" do
        project.valid?.should be_false
      end
      it "should save the error messages" do
        project.valid?
        project.errors.first.should == "'123' is not a valid project title, as it does not include any letters."
      end
    end
    context "with a duplicate title" do
      let(:project){ Project.new("Test Project 1", "Ruby", "1", "www.github.com/example", "www.example.com") }
      before do
        Project.new("Test Project 1", "Ruby", "1", "www.github.com/example", "www.example.com").save
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

  #let(:project) { Project.new("Test Title", "Ruby", "1", "www.github.com/example", "www.example.com") }

  describe "#to_s" do
    it "converts to a string with properties" do
      pending
      expect(project.to_s).to eq 'Title: Test Title, Primary language: Ruby, Student Id: 1, GitHub URL: www.github.com/example, Hosted URL: www.example.com'
    end
  end

end
