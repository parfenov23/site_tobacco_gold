class ApplicationController < ActionController::Base
  before_filter :current_user
  before_action :current_api_key
  require "api_hookah_stock"
  def current_user
    @current_user = session[:api_key].present? ? User.current_user(session[:api_key]) : nil
    @current_user
  end

  def current_api_key
    @current_api_key = if request.host == "localhost" 
      "b093dec6d556b53c69ff6e33a7b7d794" 
    elsif session[:current_magazine].blank?
      session[:current_magazine] = ApiHookahStock.find_api_key(request.host)
      session[:current_magazine]
    else
      session[:current_magazine]
    end
  end

end
