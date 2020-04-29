class ApiController < ApplicationController
  before_action :all_categories, :all_content_pages, 
  :current_api_magazine, :company_magazines, 
  :current_company, :all_top_magazine
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception

  def all_categories
    @all_categories = Category.all(current_api_key)
  end

  def all_content_pages
    @all_content_pages = ApiHookahStock.all_content_pages({api_key: current_api_key})
  end

  def current_company
    @current_company = Company.current(current_api_key)
  end

  def current_api_magazine
    @curr_magazine = company_magazines.find{|h| h["api_key"] == current_api_key}
  end

  def company_magazines
    @company_magazines = current_company.magazines(current_api_key)
  end

  def all_top_magazine
    @all_top_magazine = ApiHookahStock.all_top_magazine({api_key: current_api_key}).map{|top_item| ProductItem.new(top_item) }
  end

end
