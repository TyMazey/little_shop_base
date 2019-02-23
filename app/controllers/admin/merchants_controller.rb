class Admin::MerchantsController < Admin::BaseController
  before_action :set_merchant

  def show
    if @merchant.default?
      redirect_to admin_user_path(@merchant)
    else
      render :'/merchants/show'
    end
  end

  def downgrade
    @merchant.role = :default
    @merchant.save
    redirect_to merchants_path
  end

  def enable
    set_user_active(true)
  end

  def disable
    set_user_active(false)
  end

  private

  def set_user_active(state)
    @merchant.active = state
    @merchant.save
    redirect_to merchants_path
  end

  def set_merchant
    @merchant = User.find_by(email: params[:slug])
  end
end
