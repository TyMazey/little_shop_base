require 'rails_helper'

RSpec.describe 'as a registered user/merchant/admin' do
  before :each do
    @user = create(:user)
    @merchant = create(:merchant)
    @admin = create(:admin)
  end

  it 'shows a slug in the uri when i visit a merchant show page' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

    visit merchant_path(@merchant)

    expect(current_path).to eq("/merchants/#{@merchant.email}")
  end

  describe 'as admin' do
    it 'shows a slug for a merchant and users show page' do
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@admin)
      visit admin_merchant_path(@merchant)

      expect(current_path).to eq("/admin/merchants/#{@merchant.email}")
      visit admin_user_path(@user)

      expect(current_path).to eq("/admin/users/#{@user.email}")
    end
  end
end
