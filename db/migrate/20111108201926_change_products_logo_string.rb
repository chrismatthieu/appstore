class ChangeProductsLogoString < ActiveRecord::Migration
  def change
    change_column :products, :logo, :string
  end
end
