require_relative '../../models/project'
require_relative '../spec_helper'

describe Project do

  let(:project) { Project.new("Test Title", "Ruby", "1", "www.github.com/example", "www.example.com") }

  describe "#to_s" do
    it "converts to a string with properties" do
      expect(project.to_s).to eq 'Title: Test Title, Primary language: Ruby, Student Id: 1, GitHub URL: www.github.com/example, Hosted URL: www.example.com'
    end
  end

end
