class Cart
  attr_reader :contents, :coupon

  def initialize(initial_contents)
    @contents = initial_contents || Hash.new(0)
  end

  def items
    @contents.keys.map do |item_id|
      Item.includes(:user).find(item_id)
    end
  end

  def total_item_count
    @contents.values.sum
  end

  def count_of(item_id)
    @contents[item_id.to_s].to_i
  end

  def add_item(item_id)
    @contents[item_id.to_s] ||= 0
    @contents[item_id.to_s] += 1
  end

  def subtract_item(item_id, count=1)
    @contents[item_id.to_s] -= count
    @contents.delete(item_id.to_s) if @contents[item_id.to_s] == 0
  end

  def remove_all_of_item(item_id)
    subtract_item(item_id, count_of(item_id))
  end

  def subtotal(item_id)
    item = Item.find(item_id)
    item.price * count_of(item_id)
  end

  def grand_total
    @contents.keys.map do |item_id|
      subtotal(item_id)
    end.sum
  end

  def discounted_total
    if @coupon
      coupon = Coupon.find_by(name: @coupon)
      if coupon.dollars_off?
        total = subtotal_for_coupon_items - coupon.value
      elsif coupon.percent_off?
        total =subtotal_for_coupon_items - (subtotal_for_coupon_items * ( coupon.value.to_f / 100.00))
      end
      if total < 0
        total = 0
      else
        total
      end 
    else
      grand_total
    end
  end

  def items_for_coupon
    if @coupon
      c = Coupon.find_by(name: @coupon)
      Item.where(merchant_id: c.user_id, id: @contents.keys).pluck(:id)
    end
  end

  def subtotal_for_coupon_items
    items_for_coupon.map do |item_id|
      subtotal(item_id)
    end.sum
  end

  def add_coupon_to_cart(coupon)
    @coupon = coupon
  end
end
