require_relative '../spec_helper'

describe "Adding a student" do
  before do
    student = Student.new("Aimee", "Knight", "4")
    student.save
  end
  context "adding a unique student" do
    let!(:output){ run_nss_chronicles_with_input("2", "Jamie, Knight, 4") }
    it "should print a confirmation message" do
      output.should include("Jamie has been added.")
      Student.count.should == 2
    end
    it "should insert a new student" do
      Student.count.should == 2
    end
    it "should use the first_name we entered" do
      Student.last.first_name.should == "Jamie"
    end
  end
  context "adding a duplicate student" do
    let(:output){ run_nss_chronicles_with_input("2", "Aimee, Knight, 4") }
    it "should print an error message" do
      output.should include("Aimee already exists.")
    end
    it "should ask them to try again" do
      menu_text = "Please enter the student as first name, last name, cohort id"
      output.should include_in_order(menu_text, "already exists", menu_text)
    end
    it "shouldn't save the duplicate" do
      Student.count.should == 1
    end
    context "and trying again" do
      let!(:output){ run_nss_chronicles_with_input("2", "Aimee, Knight, 4", "Jay, Knight, 4") }
      it "should save a unique item" do
        Student.last.first_name.should == "Jay"
      end
      it "should print a success message at the end" do
        output.should include("Jay has been added")
      end
    end
  end
  context "entering an invalid looking student name" do
    context "with SQL injection" do
      let(:input){ "Bob, Smith, 4'), ('425" }
      let!(:output) { run_nss_chronicles_with_input("2", input) }
      it "should create the student without evaluating the SQL" do
        Student.last.first_name.should == "Bob"
      end
      it "shouldn't create the another student" do
        Student.count.should == 2
      end
      it "should print a success message at the end" do
        output.should include("#{Student.last.first_name} has been added")
      end
    end
    context "without alphabet characters" do
      let(:output){ run_nss_chronicles_with_input("2", "4*25") }
      it "should not save the student" do
        Student.count.should == 1
      end
      it "should print an error message" do
        output.should include("'4*25' is not a valid student first name, as it does not include any letters.")
      end
      it "should let them try again" do
        menu_text = "Please enter the student as first name, last name, cohort id"
        output.should include_in_order(menu_text, "not a valid", menu_text)
      end
    end
  end
end
