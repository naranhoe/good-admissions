class Check < ActiveRecord::Base
  validates :student_id, presence: true
  validates :deposited_date, presence: true
  validates :amount, presence: true
  belongs_to :student
  before_create :set_name_on_check

  def set_name_on_check
    if name_on_check.blank?
      self.name_on_check = self.student.full_name
    end
  end
end
