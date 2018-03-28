class ApplicationController < ActionController::Base
  require "api_hookah_stock"
  before_action :all_categories
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  before_filter :current_user

  def all_categories
    @all_categories = ApiHookahStock.categories
  end

  def current_user
    @current_user = session[:api_key].present? ? User.current_user(session[:api_key]) : nil
    @current_user
  end
end
