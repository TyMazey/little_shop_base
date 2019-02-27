class ApplicationController < ActionController::Base
  include ActionView::Helpers::TextHelper
  protect_from_forgery with: :exception

  helper_method :current_user, :current_reguser?, :current_merchant?, :current_admin?, :time_as_words
  before_action :build_cart

  def build_cart
    @cart ||= Cart.new(session[:cart])
    @cart.add_coupon_to_cart(session[:coupon])
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def current_reguser?
    current_user && current_user.default?
  end

  def current_merchant?
    current_user && current_user.merchant?
  end

  def current_admin?
    current_user && current_user.admin?
  end

  def visitor_or_user
    render file: 'errors/not_found', status: 404 unless current_user.nil? || current_reguser?
  end

  def user_or_admin
    render file: 'errors/not_found', status: 404 unless current_user && (current_reguser? || current_admin?)
  end

  def require_user
    render file: 'errors/not_found', status: 404 unless current_reguser?
  end

  def require_merchant
    render file: 'errors/not_found', status: 404 unless current_merchant?
  end

  def merchant_or_admin
    render file: 'errors/not_found', status: 404 unless current_merchant? || current_admin?
  end

  def require_admin
    render file: 'errors/not_found', status: 404 unless current_admin?
  end

  def time_as_words(time)
    time = time.split('.').first
    days = time[0..-10]
    hours = time[-8..-7]
    minutes = time[-5..-4]
    "#{days} #{pluralize(hours, 'hour')} #{pluralize(minutes, 'minute')}"
  end

end
