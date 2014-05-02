require_relative '../../models/student'
require_relative '../spec_helper'

describe Student do
  context ".all" do
    context "with no students in the database" do
      it "should return an empty array" do
        Student.all.should == []
      end
    end
    context "with multiple entries in the database" do
      before do
        Student.new("Aimee", "Knight", "4").save
        Student.new("Jamie", "Knight", "4").save
        Student.new("Jay", "Knight", "4").save
        Student.new("Bob", "Knight", "4").save
      end
      it "should return all the entries in the database" do
        first_names = Student.all.map(&:first_name)
        first_names.should == ["Aimee", "Jamie", "Jay", "Bob"]
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
      before do
        Student.new("Aimee", "Knight", "4").save
        Student.new("Jamie", "Knight", "4").save
        Student.new("Jay", "Knight", "4").save
        Student.new("Bob", "Knight", "4").save
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
      before do
        Student.new("Aimee", "Knight", "4").save
        Student.new("Jamie", "Knight", "4").save
        Student.new("Jay", "Knight", "4").save
        Student.new("Bob", "Knight", "4").save
      end
      it "should return the student with that first_name" do
        Student.find_by_first_name("Aimee").first_name.should == "Aimee"
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
      before do
        Student.new("Aimee", "Knight", "4").save
        Student.new("Jamie", "Knight", "4").save
        Student.new("Jay", "Knight", "4").save
        Student.new("Bob", "Knight", "4").save
      end
      it "should return the last student inserted" do
        Student.last.first_name.should == "Bob"
      end
    end
  end

  context "#new" do
    let(:student){ Student.new("Aimee", "Knight", "4") }
    it "should store the first_name" do
      student.first_name.should == "Aimee"
    end
  end

  context "#save" do
    let(:result){ Environment.database_connection.execute("Select first_name from students") }
    let(:student){ Student.new("Foo", "Knight", "4") }
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
      let(:student){ Student.new("123", "Knight", "4") }
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
    #let(:student) { Student.new("Aimee", "Knight", "4") }

    it "converts to a string with properties" do
      pending
      expect(student.to_s).to eq 'First Name: Aimee, Last Name: Knight, Student Id: 4'
    end
  end

end
