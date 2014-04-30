require_relative '../models/cohort'
require_relative 'spec_helper'

describe Cohort do
  context ".count" do
    context "with no cohorts in the database" do
      it "should return 0" do
        Cohort.count.should == 0
      end
    end
    context "with multiple cohorts in the database" do
      before do
        Cohort.new("Test Cohort 1").save
        Cohort.new("Test Cohort 2").save
        Cohort.new("Test Cohort 3").save
        Cohort.new("Test Cohort 4").save
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
        Cohort.new("Test Cohort 1").save
        Cohort.new("Test Cohort 2").save
        Cohort.new("Test Cohort 3").save
        Cohort.new("Test Cohort 4").save
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
        Cohort.new("Test Cohort 1").save
        Cohort.new("Test Cohort 2").save
        Cohort.new("Test Cohort 3").save
        Cohort.new("Test Cohort 4").save
      end
      it "should return the last cohort inserted" do
        Cohort.last.title.should == "Test Cohort 4"
      end
    end
  end

  context "#new" do
    let(:cohort){ Cohort.new("Test Cohort 1") }
    it "should store the title" do
      cohort.title.should == "Test Cohort 1"
    end
  end

  context "#save" do
    let(:result){ Environment.database_connection.execute("Select title from cohorts") }
    context "with a unique title" do
      let(:cohort){ Cohort.new("Test Cohort 1") }
      it "should return true" do
        cohort.save.should be_true
      end
      it "should only save one row to the database" do
        cohort.save
        result.count.should == 1
      end
      it "should actually save it to the database" do
        cohort.save
        result[0]["title"].should == "Test Cohort 1"
      end
    end
    context "with a duplicate title" do
      let(:cohort){ Cohort.new("Test Cohort 1") }
      before do
        Cohort.new("Test Cohort 1").save
      end
      it "should return false" do
        cohort.save.should be_false
      end
      it "should not save a new cohort" do
        cohort.save
        result.count.should == 1
      end
      it "should save the error messages" do
        cohort.save
        cohort.errors.first.should == "Test Cohort 1 already exists."
      end
    end
  end

  #context "#to_s" do
    #let(:cohort) { Cohort.new("Test Title", "test language 1/test language 2", "test term") }

    #it "converts to a string with properties" do
      #expect(cohort.to_s).to eq 'Title: Test Title, Primary langages: test language 1/test language 2, Term: test term'
    #end
  #end

end

