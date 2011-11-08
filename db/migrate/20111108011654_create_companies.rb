class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.string :name
      t.text :description
      t.string :website
      t.string :email
      t.string :contact
      t.string :phone
      t.binary :logo

      t.timestamps
    end
  end
end
