class UpdateTypeInCoupons < ActiveRecord::Migration[5.1]
  def change
    rename_column :coupons, :type, :coupon_type
  end
end
