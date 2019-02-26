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
    if coupon && coupon.used?
      flash[:error] = "Cannot Edit Coupon, it has been previously used."
      redirect_to dashboard_coupons_path
    elsif coupon
      @form_path = [:dashboard, coupon]
    end
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

  def destroy
    coupon = Coupon.find(params[:id])
    if coupon && coupon.used?
      flash[:error] = "Cannot Delete Coupon, it has been previously used."
    elsif coupon
      coupon.destroy
    end
    redirect_to dashboard_coupons_path
  end

  def disable
    coupon = Coupon.find(params[:id])
    set_coupon_status(coupon, 1)
  end

  def enable
    coupon = Coupon.find(params[:id])
    set_coupon_status(coupon, 0)
  end

  private
  def coupon_params
    params.require(:coupon).permit(:name, :coupon_type, :value)
  end

  def set_coupon_status(coupon, status)
    coupon.status = status
    coupon.save
    redirect_to dashboard_coupons_path
  end
end
