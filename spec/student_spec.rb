require_relative '../lib/student'
require_relative 'spec_helper'

describe Student do
  let(:student) {Student.new("Aimee", "Knight", "4")}

  it "converts to a string with properties" do
    expect(student.to_s).to eq 'First Name: Aimee, Last Name: Knight, Cohort Id: 4'
  end
end
