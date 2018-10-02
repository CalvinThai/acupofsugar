class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      	t.string :fname, null: false
      	t.string :lname, null: false
	t.string :gender, null: false
	t.text :address, null: false
	t.text :email, null: false #validate in model
	t.integer :phone_number, null: true #validate in model
	t.date :birth_date, null: false
	t.decimal :rating, null: false
	t.integer :lend_count, null: false #initialize to zero
	t.integer :borrow_count, null: false #initialize to zero
   	t.timestamps :created_date, null: false #initialize to current timestamp on creation		
	t.timestamps :updated_date, null: false
    end
  end
end
