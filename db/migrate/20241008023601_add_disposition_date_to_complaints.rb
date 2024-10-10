class AddDispositionDateToComplaints < ActiveRecord::Migration[7.0]
  def change
    add_column :complaints, :disposition_date, :datetime
    add_column :complaints, :disposition_code, :string
  end
end
