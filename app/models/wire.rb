class Wire < ActiveRecord::Base
  belongs_to :student
  before_create :set_sender

  def self.search(search)
    where("pay_date ILIKE ? OR created_at ILIKE ?", "%#{search}%", "%#{search}%")
  end

  def set_sender
    if sender.blank?
      self.sender = self.student.full_name
    end
  end
end
