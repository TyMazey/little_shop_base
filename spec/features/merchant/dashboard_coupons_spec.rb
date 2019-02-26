require 'rails_helper'

RSpec.describe 'Mechant Dashboard Coupons Page', type: :feature do
  before :each do
    @merchant = create(:merchant)
    @coupon_1 = create(:coupon, coupon_type: 0, user: @merchant)
    @coupon_2 = create(:coupon, coupon_type: 0, user: @merchant)
    @coupon_3 = create(:coupon, coupon_type: 1, user: @merchant)
  end

  it 'shows me a list of my coupons' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    visit dashboard_coupons_path

    within ".coupons" do
      expect(page).to have_content("#{@coupon_1.name}")
      expect(page).to have_content("#{@coupon_2.name}")
      expect(page).to have_content("#{@coupon_3.name}")
    end
  end

  it 'allows me to make a new coupon' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    visit dashboard_coupons_path

    click_link 'Add New Coupon'
    expect(current_path).to eq(new_dashboard_coupon_path)

    fill_in 'Name', with: 'New Coupon'
    select 'Dollars Off', from: 'Coupon type'
    fill_in 'Value', with: '25'
    click_button 'Save Coupon'

    expect(current_path).to eq(dashboard_coupons_path)
    expect(page).to have_content("You have added coupon New Coupon successfully!")
    within ".coupons" do
      expect(page).to have_content('New Coupon')
    end
  end

  it 'does not let me create a coupon with a name that already exsist' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    visit dashboard_coupons_path

    click_link 'Add New Coupon'
    expect(current_path).to eq(new_dashboard_coupon_path)

    fill_in 'Name', with: 'Coupon Name 1'
    select 'Dollars Off', from: 'Coupon type'
    fill_in 'Value', with: '25'
    click_button 'Save Coupon'

    expect(page).to have_content("New Coupon")
  end
  it 'does not let me create a coupon with a value less than or equal to 0' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    visit dashboard_coupons_path

    click_link 'Add New Coupon'
    expect(current_path).to eq(new_dashboard_coupon_path)

    fill_in 'Name', with: 'New Coupon'
    select 'Dollars Off', from: 'Coupon type'
    fill_in 'Value', with: '0'
    click_button 'Save Coupon'

    expect(page).to have_content("New Coupon")
  end

  it 'does not let me create a coupon once i have 5' do
    @coupon_4 = create(:coupon, coupon_type: 1, user: @merchant)
    @coupon_5 = create(:coupon, coupon_type: 1, user: @merchant)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    visit dashboard_coupons_path

    expect(page).to_not have_content('Add New Coupon')
    expect(page).to have_content('Youve reached your limit for Coupons.')

    visit new_dashboard_coupon_path
    fill_in 'Name', with: 'New Coupon'
    select 'Dollars Off', from: 'Coupon type'
    fill_in 'Value', with: '25'
    click_button 'Save Coupon'

    expect(page).to_not have_content('New Coupon')
  end

  it 'lets me edit a coupon' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    visit dashboard_coupons_path

    within "#coupon-#{@coupon_1.id}" do
      click_link 'Edit Coupon'
    end
      expect(current_path).to eq(edit_dashboard_coupon_path(@coupon_1))

      fill_in 'Name', with: 'Edited Coupon'
      select 'Dollars Off', from: 'Coupon type'
      fill_in 'Value', with: '30'
      click_button 'Save Coupon'

      expect(page).to have_content("You have edited coupon Edited Coupon successfully!")
  end

  it 'does not let me edit a coupon with missing information' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    visit dashboard_coupons_path

    within "#coupon-#{@coupon_1.id}" do
      click_link 'Edit Coupon'
    end
      expect(current_path).to eq(edit_dashboard_coupon_path(@coupon_1))

      fill_in 'Name', with: 'Edited Coupon'
      select 'Dollars Off', from: 'Coupon type'
      fill_in 'Value', with: ''
      click_button 'Save Coupon'

      expect(page).to_not have_content("You have edited coupon Edited Coupon successfully!")
  end

  it 'allows me to delete a coupon that has not been used' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    visit dashboard_coupons_path

    within "#coupon-#{@coupon_1.id}" do
      click_button 'Delete Coupon'
    end

    expect(page).to_not have_content("#{@coupon_1.name}")
  end

  it 'does not allow me to delete a coupon that has been used' do
    order = create(:order, coupon_id: @coupon_1.id)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    visit dashboard_coupons_path

    within "#coupon-#{@coupon_1.id}" do
      click_button 'Delete Coupon'
    end

    expect(page).to have_content("Cannot Delete Coupon, it has been previously used.")
  end

  it 'does not allow me to edit a coupon that has been used' do
    order = create(:order, coupon_id: @coupon_1.id)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    visit dashboard_coupons_path

    within "#coupon-#{@coupon_1.id}" do
      click_link 'Edit Coupon'
    end

    expect(page).to have_content("Cannot Edit Coupon, it has been previously used.")
  end

  it 'allows me to disable coupons' do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    visit dashboard_coupons_path
    within "#coupon-#{@coupon_1.id}" do
      click_button 'Disable Coupon'
      expect(page).to_not have_button('Enable Coupon')
    end
    disabled = Coupon.find(@coupon_1.id)
    expect(disabled.status).to eq('disabled')
  end

  it 'allows me to enable coupons' do
    disabled = Coupon.create(name: 'coup', coupon_type: 0, value: 20, user: @merchant, status: 1)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@merchant)
    visit dashboard_coupons_path
    within "#coupon-#{disabled.id}" do
      click_button 'Enable Coupon'
      expect(page).to_not have_button('Disable Coupon')
    end
    enabled = Coupon.find(@coupon_1.id)
    expect(enabled.status).to eq('enabled')
  end

end
