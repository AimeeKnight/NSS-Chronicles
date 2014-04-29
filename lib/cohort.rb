class Cohort
  attr_accessor :title,
                :primary_languages,
                :term

  def initialize (title, primary_languages, term)
    self.title = title
    self.primary_languages = primary_languages
    self.term = term
  end

  def to_s
    "Title: #{title}, Primary langages: #{primary_languages}, Term: #{term}"
  end

end
