class ApplicationController < ActionController::Base
  before_filter :current_user
  
  def current_user
    @current_user = session[:api_key].present? ? User.current_user(session[:api_key]) : nil
    @current_user
  end

  def current_api_key
    session[:current_magazine]
  end

end
