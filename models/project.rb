class Project
  attr_accessor :title,
                :primary_language,
                :student_id,
                :github_url,
                :hosted_url

  def initialize(title, primary_language, student_id, github_url, hosted_url)
    self.title = title
    self.primary_language = primary_language
    self.student_id = student_id
    self.github_url = github_url
    self.hosted_url = hosted_url
  end

  def to_s
    "Title: #{title}, Primary language: #{primary_language}, Student Id: #{student_id}, GitHub URL: #{github_url}, Hosted URL: #{hosted_url}"
  end
end
