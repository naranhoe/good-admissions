class Student < ActiveRecord::Base
  belongs_to :cohort
  has_many :loans
  has_many :checks
  has_many :wires
  has_many :stripes
  before_create :calculate_balance
  before_destroy :destroy_payments


  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  before_save { self.email = email.downcase }
  validates :first_name, presence: true, length: { maximum: 25 }
  validates :last_name, presence: true, length: { maximum: 25 }
  # validates :phone_num, presence: true, length: { maximum: 20 }
  validates :email, presence: true, length: { maximum: 255 }, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }

  def self.search(search)
    where("first_name ILIKE ? OR last_name ILIKE ? OR email ILIKE ?
    OR phone_num ILIKE ? OR facebook ILIKE ? OR twitter ILIKE ?
    OR linkedin ILIKE ? OR github ILIKE ?", "%#{search}%", "%#{search}%",
    "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%", "%#{search}%",
    "%#{search}%")
  end

  def search_payments(date_from, date_to)
    (loans + checks + stripes + wires).each do |student|
      if student.created_at > (date_from)  &&  student.created_at < (date_to)
        paym << student.created_at
      else
        paym = []
      end
    end
  end

  def payments
     loans + checks + stripes + wires
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def calculate_balance(deposit=0)
    self.balance -= discount
    self.balance -= deposit
  end

  def discount_difference(params)
    self.discount - params["discount"].to_i
  end

  private
  def destroy_payments
    loans.destroy_all
    checks.destroy_all
    stripes.destroy_all
    wires.destroy_all
  end
end
