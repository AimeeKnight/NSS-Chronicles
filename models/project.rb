class Project < ActiveRecord::Base
  belongs_to :student

  validates :title, uniqueness: { message: "already exists." }
  validates :title, format: { with: /[a-zA-Z]/, message: "is not a valid project title, as it does not include any letters." }

  def to_s
    "ID: #{id}, TITLE: #{title}, LANGUAGE: #{language}, STUDENT ID: #{student_id}, GITHUB URL: #{github_url}, HOSTED URL: #{hosted_url}"
  end

end
