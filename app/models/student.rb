class Student < ActiveRecord::Base
  require 'csv'
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

  def self.import(file)
    #Extract
    CSV.foreach(file.path).with_index do |row, i|

      #Transform
      if row[0].nil?
        puts "#{i} empty"
      else
        puts "#{i} not empty"
      end

      unless i == 0 || row[0].nil? #skip the first row or any row not numbered
        last_name = row[1]
        first_name = row[2]
        email = row[3]
        phone_num = row[4]
        notes = row[5]
        deposit_date = Date.strptime(row[7], '%m/%d/%Y')
        cohort = Cohort.find_by(name: "MIA9")

        #Load
        student = Student.new(first_name: first_name, last_name: last_name, email: email, phone_num: phone_num, notes: notes, created_at: deposit_date.to_datetime, cohort: cohort)
        if student.save
          student_id = student.id
          deposit = Stripe.new(student_id: student_id, amount: 1000, pay_date: deposit_date)
          puts "Student #{student.full_name} saved!"
          if deposit.save
            student.balance -= deposit.amount
            student.save
            puts "Deposit #{student.first_name} #{student.last_name} saved!"
          else
            puts "Deposit did not save for row #{i}"
          end
        else
          puts "Student #{student.first_name} did not save for row #{i}"
        end
      end
    end
  end

  private
  def destroy_payments
    loans.destroy_all
    checks.destroy_all
    stripes.destroy_all
    wires.destroy_all
  end
end
