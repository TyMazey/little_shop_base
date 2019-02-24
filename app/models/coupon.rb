class Coupon < ApplicationRecord

  belongs_to :user
  has_many :orders

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_presence_of :coupon_type
  validates_presence_of :value
  validates :value, numericality: { greater_than: 0 }

  enum coupon: [:dollars_off, :percent_off]
  enum status: [:enabled, :disabled]

  def used?
    Order.any? {|o| o.coupon_id = id }
  end
end
