require_relative '../lib/cohort'
require_relative 'spec_helper'

describe Cohort do
  let(:cohort) {Cohort.new("Test Title", "test language 1 test language 2", "test term")}

  it "converts to a string with properties" do
    expect(cohort.to_s).to eq 'Title: Test Title, Primary langages: test language 1 test language 2, Term: test term'
  end
end

