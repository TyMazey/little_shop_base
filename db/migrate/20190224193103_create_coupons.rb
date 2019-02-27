class CreateCoupons < ActiveRecord::Migration[5.1]
  def change
    create_table :coupons do |t|
      t.string :name
      t.integer :type
      t.integer :value
      t.integer :status
      t.references :user, foreign_key: true
    end
  end
end
