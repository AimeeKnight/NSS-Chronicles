require 'rspec/expectations'
$LOAD_PATH << "lib"
$LOAD_PATH << "models"
$LOAD_PATH << "controllers"

require 'environment'

Environment.environment = "test"

def run_nss_chronicles_with_input(*inputs)
  shell_output = ""
  IO.popen('ENVIRONMENT=test ./nss_chronicles', 'r+') do |pipe|
    inputs.each do |input|
      pipe.puts input
    end
    pipe.close_write
    shell_output << pipe.read
  end
  shell_output
end

RSpec.configure do |config|
  config.color_enabled = true

  config.after(:each) do
    Cohort.destroy_all
    Student.destroy_all
    Project.destroy_all
  end
end

RSpec::Matchers.define :include_in_order do |*expected|
  match do |actual|
    input = actual.delete("\n")
    regexp_string = expected.join(".*").gsub("?","\\?").gsub("\n",".*")
    result = /#{regexp_string}/.match(input)
    result.should be
  end
end
