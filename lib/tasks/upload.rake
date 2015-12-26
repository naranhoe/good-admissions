namespace :csv do
  desc "Upload a CSV file to create data in db"
  task mia8: :environment do
    require 'csv'

    #Extract
    CSV.foreach("tmp/c8_mia.csv").with_index do |row, i|

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
end
