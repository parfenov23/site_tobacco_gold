require 'vk_message'
class HomeController < ApiController
  before_filter :all_categories, :all_content_pages, :current_api_magazine, :company_magazines, :current_company, except: [:current_magazine]
  def index
  end

  def how_it_works
  end

  def category
    @items = ProductItem.new({api_key: current_api_key}).where(product_id: Category.find(params[:category_id], current_api_key).products.map(&:id) )
    sort_by_price
  end

  def products
    product = Product.new({id: params[:product_id], api_key: current_api_key})
    @items = params[:tag_id].present? ? product.find_product_items_by_tag(params[:tag_id]) : product.product_items(current_api_key)
    sort_by_price
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
    find_count_item = session[:items].select{|k| k == params[:item_id].to_i}.count
    if (find_count_item + params[:count].to_i) <= params[:max_count].to_i
      arr = params[:count].to_i.times.map{|c| params[:item_id].to_i}
      session[:items] = session[:items].present? ? (session[:items] + arr) : arr
      render json: {all: session[:items], count: session[:items].uniq.count}
    end
  end

  def rm_item_to_basket
    session[:items].delete(params[:item_id].to_i)
    @all_items = ProductItem.new({api_key: current_api_key}).where(id: session[:items])
    @all_sum = @all_items.map{|pi| pi.default_price*session[:items].count(pi.id)}.sum
    render json: {all: session[:items], count: session[:items].uniq.count, total_price: @all_sum}
  end

  def add_or_rm_count_item_basket
    count = session[:items].select{|k| k == params[:item_id].to_i}.count
    if params[:type] == "add"
      session[:items] += [params[:item_id].to_i]
      count += 1
    else
      count -= 1
      session[:items].delete(params[:item_id].to_i)
      session[:items] += count.times.map{|k| params[:item_id].to_i }
    end
    render json: {count: count}
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
    if params[:registration] == "true"
      Rails.cache.clear
      auth_user = User.registration(params[:user])
      session[:api_key] = auth_user[:api_key] if auth_user[:success]
    end
    basket = {}
    all_items_ids = all_item_basket.map(&:id)
    session[:items].map { |item| (basket[item.to_s] = basket[item.to_s].to_i + 1) if all_items_ids.include?(item.to_i)  }
    result = ApiHookahStock.order_request("", "", params.merge({basket: basket, api_key: current_api_key, user_id: current_user.id}).except(:user), "post")
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
    session[:items] = nil
    redirect_to "/"
  end

  def item
    @item = ProductItem.find(params[:id], current_api_key) 
  end

  # def mix_box
  #   @mix_box = MixBox.find(params[:id])
  # end

  def buy_rate
    # current_user.blank? ? (redirect_to "/sign_in") : nil
    @all_items = all_item_basket
    @all_sum = @all_items.map{|pi| 
      item_product = pi.product
      price = pi.current_price(current_user)
      price*session[:items].count(pi.id)
    }.sum
  end

  def cabinet
    # @visible_bar = false
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

  def sort_by_price
    if params[:price].present?
      @items = @items.select{|item| item.default_price >= params[:price][:from].to_i && item.default_price <= params[:price][:to].to_i}
    end
  end

end
