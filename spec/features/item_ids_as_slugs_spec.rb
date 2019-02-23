require 'rails_helper'

RSpec.describe 'as visitor/user/merchant/admin' do
  before :each do
    @user = create(:user)
    @merchant = create(:merchant)
    @admin = create(:admin)
    @item = create(:item)
  end
  it 'the uri path for an item uses its name not the id' do
    visit item_path(@item)
    expect(current_path).to eq("/items/#{@item.slug}")
  end

  it "uses slug for merchant items" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

    visit edit_dashboard_item_path(@item)
    expect(current_path).to eq("/dashboard/items/#{@item.slug}/edit")
  end

  it "uses slugs for admin merchant items" do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)

    visit edit_admin_merchant_item_path(@merchant, @item)
    expect(current_path).to eq("/admin/merchants/#{@merchant.slug}/items/#{@item.slug}/edit")
  end
end
