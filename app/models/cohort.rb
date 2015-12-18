class Cohort < ActiveRecord::Base
  validates :name, :location, :cohort_number, :capacity, :start_date, presence: true
  has_many :students
  before_destroy :clear_cohort_on_students

  private
  def clear_cohort_on_students
    students.each do |s|
      s.cohort_id = nil
      s.save
    end
  end
end
