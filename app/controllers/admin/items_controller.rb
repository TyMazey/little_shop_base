class Admin::ItemsController < Admin::BaseController
  before_action :set_merchant

  def index
    @items = @merchant.items
    render :'/merchants/items/index'
  end

  def new
    @item = Item.new
    @form_path = [:admin, @merchant, @item]

    render "/merchants/items/new"
  end

  def edit
    @item = Item.find_by(slug: params[:item_slug])
    @form_path = [:admin, @merchant, @item]

    render "/merchants/items/edit"
  end

  private
  def set_merchant
    @merchant = User.find_by(email: params[:merchant_slug])
  end
end
