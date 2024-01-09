# frozen_string_literal: true

require "csv"
namespace :employees do
  desc "Load employees from csv"
  task load: :environment do
    csv_text = File.read("tmp/employees.csv")
    csv = CSV.parse(csv_text, headers: true, col_sep: ";")
    csv.each do |row|
      hash = row.to_hash
      employee = Employee.find_or_create_by!(code: hash["Matricula"])
      employee.tap do |e|
        e.name = hash["Nom"]
        e.surnames = hash["Cognoms"]
        e.email = hash["mail"]
        e.status = hash["Estat"]
        e.employee_type = hash["Tipus d'Empleat"]
      end.save!
      user = Decidim::User.where(email: employee.email).first
      if user
        user.name = "#{employee.name} #{employee.surnames}"
        user.save
      end
    end
  end
end
