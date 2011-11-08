class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.integer :company_id
      t.string :name
      t.text :description
      t.string :price
      t.string :website
      t.string :platform
      t.text :buynow
      t.string :video
      t.boolean :featured
      t.binary :logo

      t.timestamps
    end
  end
end
