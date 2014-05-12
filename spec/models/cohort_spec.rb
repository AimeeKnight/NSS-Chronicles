require_relative '../spec_helper'

describe Cohort do
  context ".all" do
    context "with no cohorts in the database" do
      it "should return an empty array" do
        Cohort.all.should == []
      end
    end
    context "with multiple entries in the database" do
      let(:test_cohort_1){ Cohort.new({ title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14" }) }
      let(:test_cohort_2){ Cohort.new({ title: "Test Cohort 2", languages: "JS/Ruby", term: "Spring 14" }) }
      let(:test_cohort_3){ Cohort.new({ title: "Test Cohort 3", languages: "JS/Ruby", term: "Spring 14" }) }
      let(:test_cohort_4){ Cohort.new({ title: "Test Cohort 4", languages: "JS/Ruby", term: "Spring 14" }) }
      before do
        test_cohort_1.save
        test_cohort_2.save
        test_cohort_3.save
        test_cohort_4.save
      end
      it "should return all the entries in the database with their names and ids" do
        cohort_attrs = Cohort.all.map{ |cohort| [cohort.title, cohort.id] }
        cohort_attrs.should == [["Test Cohort 1", test_cohort_1.id],
                                ["Test Cohort 2", test_cohort_2.id],
                                ["Test Cohort 3", test_cohort_3.id],
                                ["Test Cohort 4", test_cohort_4.id]]
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
        Cohort.new({ title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14" }).save
        Cohort.new({ title: "Test Cohort 2", languages: "JS/Ruby", term: "Spring 14" }).save
        Cohort.new({ title: "Test Cohort 3", languages: "JS/Ruby", term: "Spring 14" }).save
        Cohort.new({ title: "Test Cohort 4", languages: "JS/Ruby", term: "Spring 14" }).save
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
      let(:test_cohort_1){ Cohort.new({ title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14" }) }
      before do
        test_cohort_1.save
        Cohort.new({ title: "Test Cohort 2", languages: "JS/Ruby", term: "Spring 14" }).save
        Cohort.new({ title: "Test Cohort 3", languages: "JS/Ruby", term: "Spring 14" }).save
        Cohort.new({ title: "Test Cohort 4", languages: "JS/Ruby", term: "Spring 14" }).save
      end
      it "should return the cohort with that title" do
        Cohort.find_by_title("Test Cohort 1").title.should == "Test Cohort 1"
      end
      it "should populate the id" do
        Cohort.find_by_title("Test Cohort 1").id.should == test_cohort_1.id
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
      let(:test_cohort_4){ Cohort.new({ title: "Test Cohort 4", languages: "JS/Ruby", term: "Spring 14" }) }
      before do
        Cohort.new({ title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14" }).save
        Cohort.new({ title: "Test Cohort 2", languages: "JS/Ruby", term: "Spring 14" }).save
        Cohort.new({ title: "Test Cohort 3", languages: "JS/Ruby", term: "Spring 14" }).save
        test_cohort_4.save
      end
      it "should return the last cohort inserted" do
        Cohort.last.title.should == "Test Cohort 4"
      end
      it "should return the last cohort inserted with the id populated" do
        Cohort.last.id.should == test_cohort_4.id
      end
    end
  end

  context "#new" do
    let(:cohort){ Cohort.new({ title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14" }) }
    it "should store the title" do
      cohort.title.should == "Test Cohort 1"
    end
  end

  context "#create" do
    let(:result){ Cohort.connection.execute("Select * from cohorts") }
    let(:cohort){ Cohort.create({ title: "Test Cohort Foo", languages: "JS/Ruby", term: "Spring 14" }) }
    context "with a valid cohort" do
      before do
       Cohort.any_instance.stub(:valid?){ true }
       cohort
      end
      it "should record the new id" do
        result[0]["id"].should == cohort.id
      end
      it "should only save one row to the database" do
        result.count.should == 1
      end
      it "should actually save it to the database" do
        result[0]["title"].should == "Test Cohort Foo"
      end
    end
    context "with an invalid cohort" do
      before do
        Cohort.any_instance.stub(:valid?){ false }
        cohort
      end
      it "should not save the cohort to the database" do
        result.count.should == 0
      end
    end
  end

  context "#delete" do
    let(:test_cohort_1){ Cohort.create({ title: "Test Cohort 1", languages: "JS/Ruby", term: "Summer 14" }) }
    context "with only one cohort in the database" do
      before do
        test_cohort_1.destroy
      end
      it "should delete the cohort from the database" do
        Cohort.count.should == 0
      end
    end
    context "with multiple cohorts in the database" do
    let(:test_cohort_1){ Cohort.create({ title: "Test Cohort 1", languages: "JS/Ruby", term: "Summer 14" }) }
    let!(:test_cohort_2){ Cohort.create({ title: "Test Cohort 2", languages: "JS/Ruby", term: "Summer 14" }) }
    let!(:test_cohort_3){ Cohort.create({ title: "Test Cohort 3", languages: "JS/Ruby", term: "Summer 14" }) }
      before do
        test_cohort_1.destroy
      end
      it "should only delete one cohort from the database" do
        Cohort.count.should == 2
      end
    end
  end

  context "#students" do
    let(:cohort){ Cohort.create({ title: "Test Cohort Foo", languages: "JS/Ruby", term: "Spring 14" }) }
    context "delegate to models" do
      it "should delegate to the Student" do
        expect(Student).to receive(:for_cohort)
        cohort.students
      end
    end
  end

  context "#projects" do
    let(:cohort){ Cohort.create({ title: "Test Cohort Foo", languages: "JS/Ruby", term: "Spring 14" }) }
    context "delegate to models" do
      it "should delegate to the Student" do
        expect(Student).to receive(:for_project)
        cohort.projects
      end
    end
  end

  context "#save" do
    let(:result){ Cohort.connection.execute("Select * from cohorts") }
    let(:cohort){ Cohort.create({ title: "Test Cohort Foo", languages: "JS/Ruby", term: "Spring 14" }) }
    context "with a valid cohort" do
      before do
        cohort.stub(:valid?) { true }
      end
      it "should only save one row to the database" do
        cohort.save
        result.count.should == 1
      end
      it "should recod the new id" do
        cohort.save
        cohort.id.should == result[0]["id"]
      end
      it "should actually save it to the database" do
        cohort.save
        result[0]["title"].should == "Test Cohort Foo"
      end
    end
    context "with an invalid cohort" do
      before do
        Cohort.any_instance.stub(:valid?){ false }
        cohort
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
      let(:cohort){ Cohort.create({ title: "123", languages: "JS/Ruby", term: "Spring 14" }) }
      it "should return true" do
        cohort.valid?.should be_false
        cohort.title = "Test Cohort Bar"
        cohort.valid?.should be_true
      end
    end
    context "with a unique title" do
      let(:cohort){ Cohort.create({ title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14" }) }
      it "should return true" do
        cohort.valid?.should be_true
      end
    end
    context "with an invalid title" do
      let(:cohort){ Cohort.create({ title: "123", languages: "JS/Ruby", term: "Spring 14" }) }
      it "should return false" do
        cohort.valid?.should be_false
      end
      it "should save the error messages" do
        cohort.valid?
        cohort.errors[:title].first.should == "is not a valid cohort title, as it does not include any letters."
      end
    end
    context "with a duplicate title" do
      let(:cohort){ Cohort.create({ title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14" }) }
      before do
        Cohort.new({ title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14" }).save
      end
      it "should return false" do
        cohort.valid?.should be_false
      end
      it "should save the error messages" do
        cohort.valid?
        cohort.errors[:title].first.should == "already exists."
      end
    end
  end

  context "#to_s" do
    let(:cohort){ Cohort.new({ title: "Test Cohort 1", languages: "JS/Ruby", term: "Spring 14" }) }
    it "converts to a string with properties" do
      expect(cohort.to_s).to eq "ID: #{cohort.id}, TITLE: Test Cohort 1, LANGUAGES: JS/Ruby, TERM: Spring 14"
    end
  end

end

