require_relative '../spec_helper'

describe "Adding a cohort" do
  before do
    cohort = Cohort.new(title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14")
    cohort.save
  end
  context "adding a unique cohort" do
    let!(:output){ run_nss_chronicles_with_input("1", "Test Cohort 2, JS/Ruby, Spring 14") }
    it "should print a confirmation message" do
      output.should include("Test Cohort 2 has been added.")
      Cohort.count.should == 2
    end
    it "should insert a new cohort" do
      Cohort.count.should == 2
    end
    it "should use the title we entered" do
      Cohort.last.title.should == "Test Cohort 2"
    end
  end
  context "adding a duplicate cohort" do
    let(:output){ run_nss_chronicles_with_input("1", "Test Cohort 1, JS/Ruby, Spring 14") }
    it "should print an error message" do
      output.should include("already exists.")
    end
    it "should ask them to try again" do
      menu_text = "Please enter the cohort as: title, language 1/language 2, term"
      output.should include_in_order(menu_text, "already exists", menu_text)
    end
    it "shouldn't save the duplicate" do
      Cohort.count.should == 1
    end
    context "and trying again" do
      let!(:output){ run_nss_chronicles_with_input("1", "Test Cohort 1, JS/Ruby, Spring 14", "Test Cohort 3, JS/Ruby, Spring 14") }
      it "should save a unique item" do
        Cohort.last.title.should == "Test Cohort 3"
      end
      it "should print a success message at the end" do
        output.should include("Test Cohort 3 has been added")
      end
    end
  end
  context "entering an invalid looking cohort title" do
    context "with SQL injection" do
      let(:input){ "Test Cohort 4, JS/Ruby, Spring 14'), ('425" }
      let!(:output) { run_nss_chronicles_with_input("1", input) }
      it "should create the cohort without evaluating the SQL" do
        Cohort.last.title.should == "Test Cohort 4"
      end
      it "shouldn't create the duplicate cohort" do
        Cohort.count.should == 2
      end
      it "should print a success message at the end" do
        output.should include("#{Cohort.last.title} has been added")
      end
    end
    context "without alphabet characters" do
      let(:output){ run_nss_chronicles_with_input("1", "4*25") }
      it "should not save the cohort" do
        Cohort.count.should == 1
      end
      it "should print an error message" do
        output.should include("is not a valid cohort title, as it does not include any letters.")
      end
      it "should let them try again" do
        menu_text = "Please enter the cohort as: title, language 1/language 2, term"
        output.should include_in_order(menu_text, "not a valid", menu_text)
      end
    end
  end
end
