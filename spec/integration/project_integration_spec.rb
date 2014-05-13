require_relative '../spec_helper'

describe "Adding a project" do
  before do
    project = Project.new(title: "Test Project 1", language: "Ruby", student_id: 1, github_url: "www.github.com/example", hosted_url: "www.example.com")
    project.save
  end
  context "adding a unique project" do
    let!(:output){ run_nss_chronicles_with_input("5", "Test Project 2, Ruby, 1, www.github.com/example, www.example.com") }
    it "should print a confirmation message" do
      output.should include("Test Project 2 has been added.")
      Project.count.should == 2
    end
    it "should insert a new project" do
      Project.count.should == 2
    end
    it "should use the title we entered" do
      Project.last.title.should == "Test Project 2"
    end
  end
  context "adding a duplicate project" do
    let(:output){ run_nss_chronicles_with_input("5", "Test Project 1, Ruby, 1, www.github.com/example, www.example.com") }
    it "should print an error message" do
      output.should include("already exists.")
    end
    it "should ask them to try again" do
      menu_text = "Please enter the project as: title, primary language, student id, github url, hosted url"
      output.should include_in_order(menu_text, "already exists", menu_text)
    end
    it "shouldn't save the duplicate" do
      Project.count.should == 1
    end
    context "and trying again" do
      let!(:output){ run_nss_chronicles_with_input("5", "Test Project 1, Ruby, 1, www.github.com/example, www.example.com", "Test Project 3, Ruby, 1, www.github.com/example, www.example.com") }
      it "should save a unique item" do
        Project.last.title.should == "Test Project 3"
      end
      it "should print a success message at the end" do
        output.should include("Test Project 3 has been added")
      end
    end
  end
  context "entering an invalid looking project title" do
    context "with SQL injection" do
      let(:input){ "Test Project 4, Ruby, 1, www.github.com/example, www.example.com'), ('425" }
      let!(:output) { run_nss_chronicles_with_input("5", input) }
      it "should create the project without evaluating the SQL" do
        Project.last.title.should == "Test Project 4"
      end
      it "shouldn't create another project" do
        Project.count.should == 2
      end
      it "should print a success message at the end" do
        output.should include("#{Project.last.title} has been added")
      end
    end
    context "without alphabet characters" do
      let(:output){ run_nss_chronicles_with_input("5", "4*25") }
      it "should not save the project" do
        Project.count.should == 1
      end
      it "should print an error message" do
        output.should include("is not a valid project title, as it does not include any letters.")
      end
      it "should let them try again" do
        menu_text = "Please enter the project as: title, primary language, student id, github url, hosted url"
        output.should include_in_order(menu_text, "not a valid", menu_text)
      end
    end
  end
end
