require 'vk_message'
class HomeController < ApiController
  before_filter :all_categories, :all_content_pages, :current_api_magazine, :company_magazines, :current_company, except: [:current_magazine]
  def index
    # begin
      @items = if params[:category_id].present?   
        ProductItem.new({api_key: current_api_key}).where(product_id: Category.find(params[:category_id], current_api_key).products.map(&:id) )
      elsif params[:product_id].present? 
        Product.new({}).find(params[:product_id]).product_items(current_api_key)
      else
        ProductItem.new({api_key: current_api_key}).all_present.sort_by { |hsh| hsh.count_sales }.reverse.first(20)
      end
      if params[:price].present?
        ids = @items.map do |item| 
          item_price = item.product.current_price
          item.id if item_price >= params[:price][:from].to_i && item_price <= params[:price][:to].to_i
        end.compact
        @items = ProductItem.new({api_key: current_api_key}).where(id: ids)
      end
    # rescue => error
    #   reset_session
    #   # handle_error error
    #   redirect_to "/?type=error" if params[:type] != "error"
    # end
  end

  def how_it_works
  end

  def page
    current_page = @all_content_pages.select {|page| page["url"] == params[:id] }.last
    if current_page.present?
      @title = current_page["title"]
      @content = current_page["description"]
    else
      redirect_to "/"
    end
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
    all_items_ids = all_item_basket.map(&:id)
    session[:items].map { |item| (basket[item.to_s] = basket[item.to_s].to_i + 1) if all_items_ids.include?(item.to_i)  }
    result = ApiHookahStock.order_request("", "", params.merge({basket: basket, api_key: current_api_key}), "post")
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
    @item = ProductItem.find(params[:id], current_api_key) 
  end

  # def mix_box
  #   @mix_box = MixBox.find(params[:id])
  # end

  def buy_rate
    current_user.blank? ? (redirect_to "/sign_in") : nil
    @all_items = all_item_basket
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

  private

  def all_item_basket
    ProductItem.new({api_key: current_api_key}).where(id: session[:items])
  end

end
