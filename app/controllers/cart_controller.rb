class CartController < ApplicationController
  before_action :visitor_or_user
  before_action :set_item_id, only: [:add, :remove_all_of_item, :add_more_item, :remove_more_item]
  include ActionView::Helpers::TextHelper

  def show
    @items = @cart.items
  end

  def destroy
    session.delete(:cart)
    redirect_to cart_path
  end

  def add
    add_item_to_cart(@item)
    redirect_to items_path
  end

  def remove_all_of_item
    remove_item(@item)
    redirect_to cart_path
  end

  def add_more_item
    add_item_to_cart(@item)
    redirect_to cart_path
  end

  def remove_more_item
    remove_item(@item, 1)
    redirect_to cart_path
  end

  def add_coupon
    if current_user.used_coupon?(params[:coupon])
      flash[:error] = "Sorry You Have Already Used That Coupon."
      redirect_to cart_path
    else
      @cart.add_coupon_to_cart(params[:coupon])
      flash[:success] = "You have added the coupon to your order."
      session[:coupon] = @cart.coupon
      redirect_to cart_path
    end
  end

  private

  def remove_item(item, count=nil)
    item = Item.find(item.id)
    if count.nil?
      @cart.remove_all_of_item(item.id)
      flash[:success] = "You have removed all packages of #{item.name} from your cart"
    else
      @cart.subtract_item(item.id)
      flash[:success] = "You have removed 1 package of #{item.name} from your cart, new quantity is #{@cart.count_of(item.id)}"
    end
    session[:cart] = @cart.contents
  end

  def add_item_to_cart(item)
    if item
      item = Item.where(id: item.id).first
      @cart.add_item(item.id)
      flash[:success] = "You have #{pluralize(@cart.count_of(item.id), 'package')} of #{item.name} in your cart"
      session[:cart] = @cart.contents
    else
      flash[:error] = 'Cannot add that item'
    end
  end

  def set_item_id
    @item = Item.find_by(slug: params[:slug])
  end

end
