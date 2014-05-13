require_relative 'student'

class Cohort < ActiveRecord::Base
  has_many :students
  has_many :projects, through: :students

  validates :title, uniqueness: { message: "already exists." }
  validates :title, format: { with: /[a-zA-Z]/, message: "is not a valid cohort title, as it does not include any letters." }

  def to_s
    "ID: #{id}, TITLE: #{title}, LANGUAGES: #{languages}, TERM: #{term}"
  end

end
