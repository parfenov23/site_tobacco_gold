require 'vk_message'
class HomeController < ApiController
  before_filter :all_categories, :all_content_pages, :current_api_magazine, 
  :company_magazines, :current_company, :all_top_magazine,
  except: [
    :current_magazine, :update_user_contact, 
    :send_item_to_basket, :user_reset_password, 
    :add_item_to_basket, :rm_item_to_basket, :add_or_rm_count_item_basket,
    :ajax_search_product_item
  ]
  def index
    if params[:type] == "json"
      html_form = render_to_string "/home/index", :layout => false
      render text: html_form
    end
  end

  def how_it_works
  end

  def category
    # @items = ProductItem.new({api_key: current_api_key}).where(product_id: Category.find(params[:category_id], current_api_key).products.map(&:id) )
    # sort_by_price
    if params[:type] == "json"
      html_form = render_to_string "/home/category", :layout => false
      render text: html_form
    end
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
    find_count_item = session[:items].present? ? session[:items].select{|k| k == params[:item_id].to_i}.count : 0
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
      Rails.cache.clear rescue nil
      user_email = "#{params[:request][:user_phone].gsub(" ","").gsub("-","")}-#{SecureRandom.hex(4)}@crm-stock.ru"
      pssword = SecureRandom.hex(8)
      user_params = {
        api_key: current_api_key,
        user: {email: user_email, password: pssword, password_confirmation: pssword},
        contact: {first_name: params[:request][:user_name], phone: params[:request][:user_phone]}
      }
      auth_user = User.registration(user_params)
      session[:api_key] = auth_user[:api_key] if auth_user[:success]
    end
    basket = {}
    all_items_ids = all_item_basket.map(&:id)
    session[:items].map { |item| (basket[item.to_s] = basket[item.to_s].to_i + 1) if all_items_ids.include?(item.to_i)  }
    result = ApiHookahStock.order_request("", "", params.merge({basket: basket, api_key: current_api_key, user_id: current_user.id}).except(:user), "post")
    Rails.cache.clear rescue nil
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
    if (current_user.contact.present? rescue false)
      @contact = current_user.contact
    else
      redirect_to "/"
    end
  end

  def redirect_to_index
    redirect_to "/"
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

  def update_user_contact
    ApiHookahStock.contacts(current_user.contact.id, "", params.merge({api_key: current_api_key}), "put")
    render json: {success: true}
  end

  def user_reset_password
    render json: ApiHookahStock.users("", "/reset_password", params.merge({api_key: current_api_key}))
  end

  def show_pdf_order_request
    data = open("#{ApiHookahStock.url}/order_invoice/#{params[:id]}.pdf?key=#{params[:time]}").read
    send_data data, type: 'application/pdf', disposition: 'inline'
  end

  def ajax_search_product_item
    render json: ApiHookahStock.product_items("", "/search", params.merge({api_key: current_api_key})).map{|pi| 
      product_item = ProductItem.new(pi)
      product_item.as_json.merge({"current_img" => product_item.current_img})
    }
  end

  def ajax_find_address
    connection = Faraday.new 
    fetched_page = connection.post do |request|
      request.url "https://kladr-api.ru/api.php?query=#{params[:city]}&contentType=city&limit=10&token=rYa224GhZe8dNF7Qt8eD6Zdf3D243zf5"
      request.headers['Content-Type'] = 'application/json'
    end
    json_city = JSON.parse(fetched_page.body)

    city_id = json_city["result"][1].present? ? json_city["result"][1]["id"] : 0
    arr_streets = []
    if city_id != 0
      connection = Faraday.new
      fetched_page = connection.post do |request|
        request.url "https://kladr-api.ru/api.php?query=#{params[:street]}&contentType=street&cityId=#{city_id}"
        request.headers['Content-Type'] = 'application/json'
      end
      arr_streets = JSON.parse(fetched_page.body)["result"].map{|r| r if r["id"] != "Free"}.compact.uniq! {|e| e["name"] }
    end
    render json: arr_streets
  end

  private

  def all_item_basket
    ProductItem.new({api_key: current_api_key}).where(id: session[:items])
  end

  def sort_by_price
    if params[:price].present?
      @items = @items.select{|item| item.default_price >= params[:price][:from].to_i && item.default_price <= params[:price][:to].to_i}
    end
    if params[:sort].present?
      @items = @items.sort {|a,b| a.current_price(current_user) <=> b.current_price(current_user)} if params[:sort] == "price" || params[:sort] == "priceASC"
      @items = @items.sort {|a,b| a.title <=> b.title} if params[:sort] == "title" || params[:sort] == "titleASC"
      @items = @items.reverse if params[:sort].scan("ASC").present?
    end
  end

end
