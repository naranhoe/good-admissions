class Stripe < ActiveRecord::Base
  validates :student_id, :amount, :pay_date, presence: true
  belongs_to :student
end
