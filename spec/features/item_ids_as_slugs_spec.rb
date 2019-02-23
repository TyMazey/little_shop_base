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
end
