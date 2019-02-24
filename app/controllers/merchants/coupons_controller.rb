class Merchants::CouponsController < ApplicationController
  before_action :merchant_or_admin, only: [:index]

  def index
    @coupons = Coupon.where(user: current_user)
  end

  def new
    @coupon = Coupon.new
    @form_path = [:dashboard, @coupon]
  end

  def create
    @merchant = current_user
    @coupon = @merchant.coupons.new(coupon_params)
    if Coupon.where(user: current_user).count < 5
      if @coupon.save
        flash[:success] = "You have added coupon #{@coupon.name} successfully!"
        redirect_to dashboard_coupons_path
      else
        @form_path = [:dashboard, @coupon]
        render :new
      end
    else
      redirect_to dashboard_coupons_path
    end
  end

  def edit
    coupon = Coupon.find(params[:id])
    @form_path = [:dashboard, coupon]
  end

  def update
    @merchant = current_user
    @coupon = Coupon.find(params[:id])
    if @coupon.update(coupon_params)
      flash[:success] = "You have edited coupon #{@coupon.name} successfully!"
      redirect_to dashboard_coupons_path
    else
      @form_path = [:dashboard, @coupon]
      render :edit
    end
  end

  private
  def coupon_params
    params.require(:coupon).permit(:name, :coupon_type, :value)
  end
end
