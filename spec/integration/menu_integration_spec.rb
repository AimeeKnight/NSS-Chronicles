require_relative '../spec_helper'

describe "Menu Integration" do
  let(:menu_text) do
<<EOS
What do you want to do?
1. Add Cohort
2. Show Cohorts
3. Add Student
4. Show Students
5. Add Project
EOS
  end
  context "the menu displays on startup" do
    let(:shell_output){ run_nss_chronicles_with_input() }
    it "should print the menu" do
      shell_output.should include(menu_text)
    end
  end
  context "the user selects 1" do
    let(:shell_output){ run_nss_chronicles_with_input("1") }
    it "should print the next menu" do
      shell_output.should include("Please enter the cohort as: title, language 1/language 2, term")
    end
  end
  context "the user selects 2" do
    let(:shell_output){ run_nss_chronicles_with_input("3") }
    it "should print the next menu" do
      shell_output.should include("Please enter the student as first name, last name, cohort id")
    end
  end
  context "the user selects 3" do
    let(:shell_output){ run_nss_chronicles_with_input("5") }
    it "should print the next menu" do
      shell_output.should include("Please enter the project as: title, primary language, student id, github url, hosted url")
    end
  end
  context "if the user types in the wrong input" do
    let(:shell_output){ run_nss_chronicles_with_input("10") }
    it "should print the menu again" do
      shell_output.should include_in_order(menu_text, "10", menu_text)
    end
    it "should include an appropriate error message" do
      shell_output.should include("'10' is not a valid selection")
    end
  end
  context "if the user types in no input" do
    let(:shell_output){ run_nss_chronicles_with_input("") }
    it "should print the menu again" do
      shell_output.should include_in_order(menu_text, menu_text)
    end
    it "should include an appropriate error message" do
      shell_output.should include("'' is not a valid selection")
    end
  end
  context "if the user types in incorrect input, it should allow correct input" do
    let(:shell_output){ run_nss_chronicles_with_input("10", "5") }
    it "should include the appropriate menu" do
      shell_output.should include("Please enter the project as: title, primary language, student id, github url, hosted url")
    end
  end
  context "if the user types in incorrect input multiple times, it should allow correct input" do
    let(:shell_output){ run_nss_chronicles_with_input("10", "", "1") }
    it "should include the appropriate menu" do
      shell_output.should include("Please enter the cohort as: title, language 1/language 2, term")
    end
  end
end
