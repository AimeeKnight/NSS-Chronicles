require_relative '../spec_helper'

describe Cohort do
  context ".all" do
    context "with no cohorts in the database" do
      it "should return an empty array" do
        Cohort.all.should == []
      end
    end
    context "with multiple entries in the database" do
      before do
        Cohort.new("Test Cohort 1", "JS/Ruby", "Spring 14").save
        Cohort.new("Test Cohort 2", "JS/Ruby", "Spring 14").save
        Cohort.new("Test Cohort 3", "JS/Ruby", "Spring 14").save
        Cohort.new("Test Cohort 4", "JS/Ruby", "Spring 14").save
      end
      it "should return all the entries in the database" do
        titles = Cohort.all.map(&:title)
        titles.should == ["Test Cohort 1", "Test Cohort 2", "Test Cohort 3", "Test Cohort 4"]
      end
    end
  end

  context ".count" do
    context "with no cohorts in the database" do
      it "should return 0" do
        Cohort.count.should == 0
      end
    end
    context "with multiple cohorts in the database" do
      before do
        Cohort.new("Test Cohort 1", "JS/Ruby", "Spring 14").save
        Cohort.new("Test Cohort 2", "JS/Ruby", "Spring 14").save
        Cohort.new("Test Cohort 3", "JS/Ruby", "Spring 14").save
        Cohort.new("Test Cohort 4", "JS/Ruby", "Spring 14").save
      end
      it "should return the correct count" do
        Cohort.count.should == 4
      end
    end
  end

  context ".find_by_title" do
    context "with no cohorts in the database" do
      it "should return 0" do
        Cohort.find_by_title("Test Cohort 1").should be_nil
      end
    end
    context "given a cohort with the passed title in the database" do
      before do
        Cohort.new("Test Cohort 1", "JS/Ruby", "Spring 14").save
        Cohort.new("Test Cohort 2", "JS/Ruby", "Spring 14").save
        Cohort.new("Test Cohort 3", "JS/Ruby", "Spring 14").save
        Cohort.new("Test Cohort 4", "JS/Ruby", "Spring 14").save
      end
      it "should return the cohort with that title" do
        Cohort.find_by_title("Test Cohort 1").title.should == "Test Cohort 1"
      end
    end
  end

  context ".last" do
    context "with no cohorts in the database" do
      it "should return nil" do
        Cohort.last.should be_nil
      end
    end
    context "with multiple cohorts in the database" do
      before do
        Cohort.new("Test Cohort 1", "JS/Ruby", "Spring 14").save
        Cohort.new("Test Cohort 2", "JS/Ruby", "Spring 14").save
        Cohort.new("Test Cohort 3", "JS/Ruby", "Spring 14").save
        Cohort.new("Test Cohort 4", "JS/Ruby", "Spring 14").save
      end
      it "should return the last cohort inserted" do
        Cohort.last.title.should == "Test Cohort 4"
      end
    end
  end

  context "#new" do
    let(:cohort){ Cohort.new("Test Cohort 1", "JS/Ruby", "Spring 14") }
    it "should store the title" do
      cohort.title.should == "Test Cohort 1"
    end
  end

  context "#save" do
    let(:result){ Environment.database_connection.execute("Select title from cohorts") }
    let(:cohort){ Cohort.new("Test Cohort Foo", "JS/Ruby", "Spring 14") }
    context "with a valid cohort" do
      before do
        cohort.stub(:valid?) { true }
      end
      it "should only save one row to the database" do
        cohort.save
        result.count.should == 1
      end
      it "should actually save it to the database" do
        cohort.save
        result[0]["title"].should == "Test Cohort Foo"
      end
    end
    context "with an invalid cohort" do
      before do
        cohort.stub(:valid?) { false }
      end
      it "should not save a new cohort to the database" do
        cohort.save
        result.count.should == 0
      end
    end
  end

  context "#valid?" do
    let(:result){ Environment.database_connection.execute("Select title from cohorts") }
    context "after fixing the errors" do
      let(:cohort){ Cohort.new("123", "JS/Ruby", "Spring 14") }
      it "should return true" do
        cohort.valid?.should be_false
        cohort.title = "Test Cohort Bar"
        cohort.valid?.should be_true
      end
    end
    context "with a unique title" do
      let(:cohort){ Cohort.new("Test Cohort 1", "JS/Ruby", "Spring 14") }
      it "should return true" do
        cohort.valid?.should be_true
      end
    end
    context "with an invalid title" do
      let(:cohort){ Cohort.new("123", "JS/Ruby", "Spring 14") }
      it "should return false" do
        cohort.valid?.should be_false
      end
      it "should save the error messages" do
        cohort.valid?
        cohort.errors.first.should == "'123' is not a valid cohort title, as it does not include any letters."
      end
    end
    context "with a duplicate title" do
      let(:cohort){ Cohort.new("Test Cohort 1", "JS/Ruby", "Spring 14") }
      before do
        Cohort.new("Test Cohort 1", "JS/Ruby", "Spring 14").save
      end
      it "should return false" do
        cohort.valid?.should be_false
      end
      it "should save the error messages" do
        cohort.valid?
        cohort.errors.first.should == "Test Cohort 1 already exists."
      end
    end
  end

  context "#to_s" do
    #let(:cohort){ Cohort.new("Test Cohort 1", "JS/Ruby", "Spring 14") }

    it "converts to a string with properties" do
      pending
      expect(cohort.to_s).to eq 'Title: Test Title, Primary langages: test language 1/test language 2, Term: test term'
    end
  end

end

