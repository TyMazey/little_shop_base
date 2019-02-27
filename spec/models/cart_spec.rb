require 'rails_helper'

RSpec.describe Cart do
  it '.total_count' do
    cart = Cart.new({
      '1' => 2,
      '2' => 3
    })
    expect(cart.total_item_count).to eq(5)
  end

  it '.items' do
    item_1, item_2 = create_list(:item, 2)
    cart = Cart.new({})
    cart.add_item(item_1.id)
    cart.add_item(item_2.id)

    expect(cart.items).to eq([item_1, item_2])
  end

  it '.count_of' do
    cart = Cart.new({})
    expect(cart.count_of(5)).to eq(0)

    cart = Cart.new({
      '2' => 3
    })
    expect(cart.count_of(2)).to eq(3)
  end

  it '.add_item' do
    cart = Cart.new({
      '1' => 2,
      '2' => 3
    })

    cart.add_item(1)
    cart.add_item(2)
    cart.add_item(3)

    expect(cart.contents).to eq({
      '1' => 3,
      '2' => 4,
      '3' => 1
      })
  end

  it '.remove_all_of_item' do
    cart = Cart.new({
      '1' => 2,
      '2' => 3
    })

    cart.remove_all_of_item(1)

    expect(cart.contents).to eq({
      '2' => 3
    })
  end

  it '.subtract_item' do
    cart = Cart.new({
      '1' => 2,
      '2' => 3
    })

    cart.subtract_item(1)
    cart.subtract_item(1)
    cart.subtract_item(2)

    expect(cart.contents).to eq({
      '2' => 2
      })
  end

  it '.subtotal' do
    item_1 = create(:item)
    cart = Cart.new({})
    cart.add_item(item_1.id)
    cart.add_item(item_1.id)
    cart.add_item(item_1.id)

    expect(cart.subtotal(item_1.id)).to eq(item_1.price * cart.total_item_count)
  end

  it '.grand_total' do
    item_1, item_2 = create_list(:item, 2)
    cart = Cart.new({})
    cart.add_item(item_1.id)
    cart.add_item(item_1.id)
    cart.add_item(item_2.id)
    cart.add_item(item_2.id)
    cart.add_item(item_2.id)

    expect(cart.grand_total).to eq(cart.subtotal(item_1.id) + cart.subtotal(item_2.id))
  end

  it '.add_coupon_to_cart' do
    cart = Cart.new({})
    merchant = create(:merchant)
    item_1, item_2 = create_list(:item, 2, user: merchant)
    coupon = create(:coupon, coupon_type: 0, value: 1, user: merchant)

    cart.add_coupon_to_cart(coupon.name)

    expect(cart.coupon).to eq("Coupon Name 1")
  end

  it '.items_for_coupon' do
    cart = Cart.new({})
    merchant = create(:merchant)
    item_1, item_2 = create_list(:item, 2, user: merchant)
    item_3 = create(:item)
    coupon = create(:coupon, coupon_type: 0, value: 1, user: merchant)
    cart.add_item(item_1.id)
    cart.add_item(item_2.id)
    cart.add_item(item_3.id)

    cart.add_coupon_to_cart(coupon.name)

    expect(cart.items_for_coupon).to eq([item_1.id, item_2.id])
  end

  it '.items_not_for_coupon' do
    cart = Cart.new({})
    merchant = create(:merchant)
    item_1, item_2 = create_list(:item, 2, user: merchant)
    item_3 = create(:item)
    coupon = create(:coupon, coupon_type: 0, value: 1, user: merchant)
    cart.add_item(item_1.id)
    cart.add_item(item_2.id)
    cart.add_item(item_3.id)

    cart.add_coupon_to_cart(coupon.name)

    expect(cart.items_not_for_coupon).to eq([item_3.id])
  end

  it '.subtotal_for_coupon_items' do
    cart = Cart.new({})
    merchant = create(:merchant)
    item_1, item_2 = create_list(:item, 2, user: merchant)
    item_3 = create(:item)
    coupon = create(:coupon, coupon_type: 0, value: 1, user: merchant)
    cart.add_item(item_1.id)
    cart.add_item(item_2.id)
    cart.add_item(item_3.id)

    cart.add_coupon_to_cart(coupon.name)

    expect(cart.subtotal_for_coupon_items).to eq(7.5)
  end

  it '.non_applied_coupon_total' do
    cart = Cart.new({})
    merchant = create(:merchant)
    item_1, item_2 = create_list(:item, 2, user: merchant)
    item_3 = create(:item)
    coupon = create(:coupon, coupon_type: 0, value: 1, user: merchant)
    cart.add_item(item_1.id)
    cart.add_item(item_2.id)
    cart.add_item(item_3.id)

    cart.add_coupon_to_cart(coupon.name)

    expect(cart.non_applied_coupon_total).to eq(6)
  end

  it '.applied_coupon_total when dollar off coupon' do
    cart = Cart.new({})
    merchant = create(:merchant)
    item_1, item_2 = create_list(:item, 2, user: merchant)
    item_3 = create(:item)
    coupon = create(:coupon, coupon_type: 0, value: 1, user: merchant)
    cart.add_item(item_1.id)
    cart.add_item(item_2.id)
    cart.add_item(item_3.id)

    cart.add_coupon_to_cart(coupon.name)

    expect(cart.applied_coupon_total).to eq(6.5)
  end

  it '.applied_coupon_total when dollar off exeeds cart pirce is 0' do
    cart = Cart.new({})
    merchant = create(:merchant)
    item_1, item_2 = create_list(:item, 2, user: merchant)
    item_3 = create(:item)
    coupon = create(:coupon, coupon_type: 0, value: 100, user: merchant)
    cart.add_item(item_1.id)
    cart.add_item(item_2.id)
    cart.add_item(item_3.id)

    cart.add_coupon_to_cart(coupon.name)

    expect(cart.applied_coupon_total).to eq(0)
  end

  it '.applied_coupon_total when percent off coupon' do
    cart = Cart.new({})
    merchant = create(:merchant)
    item_1, item_2 = create_list(:item, 2, user: merchant)
    item_3 = create(:item)
    coupon = create(:coupon, coupon_type: 1, value: 50, user: merchant)
    cart.add_item(item_1.id)
    cart.add_item(item_2.id)
    cart.add_item(item_3.id)

    cart.add_coupon_to_cart(coupon.name)

    expect(cart.applied_coupon_total).to eq(3.75)
  end

  it '.discounted_total' do
    cart = Cart.new({})
    merchant = create(:merchant)
    item_1, item_2 = create_list(:item, 2,user: merchant)
    coupon = create(:coupon, coupon_type: 0, value: 1, user: merchant)
    cart.add_coupon_to_cart(coupon.name)
    cart.add_item(item_1.id)
    cart.add_item(item_1.id)
    cart.add_item(item_2.id)
    cart.add_item(item_2.id)
    cart.add_item(item_2.id)

    expect(cart.discounted_total).to eq(cart.non_applied_coupon_total + cart.applied_coupon_total)
  end

  it '.discounted_total with no coupon' do
    cart = Cart.new({})
    merchant = create(:merchant)
    item_1, item_2 = create_list(:item, 2,user: merchant)
    cart.add_item(item_1.id)
    cart.add_item(item_1.id)
    cart.add_item(item_2.id)
    cart.add_item(item_2.id)
    cart.add_item(item_2.id)

    expect(cart.discounted_total).to eq(cart.grand_total)
  end
end
