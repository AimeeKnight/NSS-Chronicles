class Student < ActiveRecord::Base
  belongs_to :cohort
  has_many :projects

  validates :first_name, uniqueness: { message: "already exists." }
  validates :first_name, format: { with: /[a-zA-Z]/, message: "is not a valid student first name, as it does not include any letters." }
  before_save :make_sure_alumni_set, if: -> { alumni.nil? }

  def to_s
    "ID: #{id}, FIRST NAME: #{first_name}, LAST NAME: #{last_name}, COHORT ID: #{cohort_id}, ALUMNI: #{alumni}"
  end

  scope :alumni, -> { where alumni: true }
  scope :find_by_first_and_last_name, ->(first_name, last_name) { where first_name: first_name, last_name: last_name }

  def make_alumni
    self.alumni = true
    self.save!
    @alumni = true
  end

  def make_sure_alumni_set
    if alumni.nil?
      self.alumni = false 
    end
    true
  end

end
