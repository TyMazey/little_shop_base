class Admin::OrdersController < Admin::BaseController
  def index
    user = User.find(params[:user_id])
    @orders = user.orders
    render :'/profile/orders/index'
  end

  def show
    @user = User.find(params[:user_id])
    @order = Order.find(params[:id])

    if @order.user_id != @user.id
      render file: 'errors/not_found', status: 404
    else
      render '/profile/orders/show'
    end
  end

  def merchant_show
    @merchant = User.find(params[:merchant_id])
    @order = Order.find(params[:id])
    @user = @order.user
    @order_items = @order.order_items_for_merchant(@merchant.id)

    render '/merchants/orders/show'
  end
end
