require 'rails_helper'

RSpec.describe Coupon, type: :model do

  describe 'validations' do
    it {should validate_presence_of :name}
    it {should validate_uniqueness_of :name}
    it {should validate_presence_of :coupon_type}
    it {should validate_presence_of :value}
    it { should validate_numericality_of(:value).is_greater_than(0) }
  end

  describe 'relationships' do
    it {should belong_to :user}
    it {should have_many :orders}
  end

  describe 'instance methods' do
    it '.used?' do
      user = create(:user)
      coupon = create(:coupon, coupon_type: 0, value: 100, user: user)

      expect(coupon.used?).to eq(false)

      order = create(:order, coupon_id: coupon.id)
      expect(coupon.used?).to eq(true)
    end
  end
end
