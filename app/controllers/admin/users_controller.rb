class Admin::UsersController < Admin::BaseController
  before_action :set_user
  def index
    @users = User.where(role: 0).order(:name)
  end

  def show
    if @user.merchant?
      redirect_to admin_merchant_path(@user)
    else
      render :'/users/show'
    end
  end

  def edit
    @form_path = [:admin, @user]
    render :'/users/edit'
  end

  def update
    if @user.update(user_params)
      flash[:success] = "Profile has been updated"
      redirect_to admin_user_path(@user)
    end
  end

  def upgrade
    @user.role = :merchant
    @user.save
    redirect_to admin_users_path
  end

  def disable
    set_active_flag(@user, false)
    redirect_to admin_users_path
  end

  def enable
    set_active_flag(@user, true)
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :address, :city, :state, :zip, :password)
  end

  def set_active_flag(user, active_flag)
    user.active = active_flag
    user.save
  end

  def set_user
    @user = User.find_by(email: params[:slug])
  end
end
