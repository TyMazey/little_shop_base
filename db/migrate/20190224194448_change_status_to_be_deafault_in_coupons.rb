class ChangeStatusToBeDeafaultInCoupons < ActiveRecord::Migration[5.1]
  def change
    change_column :coupons, :status, :integer, default: 0
  end
end
