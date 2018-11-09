require 'vk_message'
class HomeController < ApplicationController
  # before_filter :redirect_test, except: [:callback_vk, :auth]
  def index
    # begin
      @items = if params[:category_id].present?   
        ProductItem.new({api_key: session[:current_magazine]}).where(product_id: Category.find(params[:category_id]).products.map(&:id) )
      elsif params[:product_id].present? 
        Product.new({}).find(params[:product_id]).product_items(session[:current_magazine])
      else
        ProductItem.new({api_key: session[:current_magazine]}).all_present.sort_by { |hsh| hsh.count_sales }.reverse.first(20)
      end
      if params[:price].present?
        ids = @items.map do |item| 
          item_price = item.product.current_price
          item.id if item_price >= params[:price][:from].to_i && item_price <= params[:price][:to].to_i
        end.compact
        @items = ProductItem.new({api_key: session[:current_magazine]}).where(id: ids)
      end
    # rescue => error
    #   reset_session
    #   # handle_error error
    #   redirect_to "/?type=error" if params[:type] != "error"
    # end
  end

  def how_it_works
  end

  def add_item_to_basket
    arr = params[:count].to_i.times.map{|c| params[:item_id].to_i}
    # binding.pry
    session[:items] = session[:items].present? ? (session[:items] + arr) : arr
    render json: {all: session[:items], count: session[:items].uniq.count}
  end

  def rm_item_to_basket
    session[:items].delete(params[:item_id].to_i)
    @all_items = ProductItem.new({}).where(id: session[:items])
    @all_sum = @all_items.map{|pi| pi.product.current_price*session[:items].count(pi.id)}.sum
    render json: {all: session[:items], count: session[:items].uniq.count, total_price: @all_sum}
  end

  def redirect_test
    redirect_to "/stock" if ((!current_user.admin) rescue true)
  end

  def auth
    redirect_to "/sign_in"
  end

  def login
  end

  def registration
  end

  def send_item_to_basket
    basket = {}
    session[:items].map { |item| basket[item.to_s] = basket[item.to_s].to_i + 1 }
    result = ApiHookahStock.order_request("", "", params.merge({basket: basket, api_key: session[:current_magazine]}), "post")
    Rails.cache.clear
    session[:items] = nil
    render json: result
  end

  def callback_vk
    VkMessage.message_price(params)
    render text: "5bbf068d"
  end

  def current_magazine
    session[:current_magazine] = params[:current_magazine]
    redirect_to "/"
  end

  def item
    @item = ProductItem.find(params[:id]) 
  end

  def mix_box
    @mix_box = MixBox.find(params[:id])
  end

  def buy_rate
    current_user.blank? ? (redirect_to "/sign_in") : nil
    @all_items = ProductItem.new({api_key: session[:current_magazine]}).where(id: session[:items])
    @all_sum = @all_items.map{|pi| 
      item_product = pi.product
      price = pi.current_price(current_user)
      price*session[:items].count(pi.id)
    }.sum
  end

  def cabinet
    @visible_bar = false
    @contact = current_user.contact
  end

  def callback_vk
    VkMessage.message_price(params)
    render text: "5bbf068d"
  end

  def show_sale
    @sale = current_user.contact.sales.select{|sale|sale.id == params[:id].to_i}.last
    if @sale.present?
      respond_to do |format|
        format.html
        format.pdf{
          render pdf: "#{@sale.id}_#{Time.now.to_i}"
        }
      end
    else
      redirect_to "/cabinet"
    end
  end

end
