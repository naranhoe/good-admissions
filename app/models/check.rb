class Check < ActiveRecord::Base
  validates :student_id, :amount, :pay_date, :check_number, presence: true
  belongs_to :student
  before_create :set_name_on_check

  def set_name_on_check
    if name_on_check.blank?
      self.name_on_check = self.student.full_name
    end
  end
end
