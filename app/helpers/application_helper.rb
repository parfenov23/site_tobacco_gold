module ApplicationHelper
  def check_if_true(item)
    if(item == 'true' or item == true or item == 1 or item == '1')
      return true
    else
      return false
    end
  end

  # Заголовок страницы
  def layout_title
    d = @page_title.nil? ? "" : " | "
    @page_title.to_s + d + "Tobacco Gold Екатеринбург"
  end

  def title(page_title=nil)
    @page_title = page_title
  end

  def page_title(default_title = '')
    @page_title || default_title
  end

  def default_ava_link
    '/uploads/ava.jpg'
  end

  def default_img_product(model)
    model.image_url.present? ? model.image_url : model.product.default_img
  end

  def user_ava(avatar)
    if avatar.to_s != ""
      "data:image/png;base64," + avatar
    else
      default_ava_link
    end
  end

  def current_user_admin?
    current_user.admin || current_user.is_admin? || current_user.is_manager? rescue false
  end

  def current_magazine
    current_user.magazine
  end

  def all_pages
    [
      ["Как это работает", "how_it_works"],
      ["Контакты", "contacts"],
      ["Бонусы", "bonuses"],
      ["Пополнить счет", "buy_rate"]
    ]
  end

  def left_bar_links
    all_menu = [
      # {type: 'buy_rate', title: 'Пополнить счет', href: '/buy_rate'},
      {type: 'how_it_works', title: 'Доставка и оплата', href: '/how_it_works'},
      # {type: 'winners', title: 'Рейтинг', href: '/winners'},
      {type: 'bonuses', title: 'Скидки и Акции', href: '/bonus'},
      # {type: 'faq', title: 'F.A.Q', href: '/help'},
      {type: 'contacts', title: 'Контакты', href: '/contacts'}
    ]
    all_menu << {type: 'participant', title: 'Админка', href: '/admin/admin'} if current_user_present_and_control
    all_menu
  end

  def rus_case(count, n1, n2, n3)
    "#{count} #{Russian.p(count, n1, n2, n3)}"
  end

  def current_user_present_and_control
    current_user.present? ? current_user.is_admin? || current_user.is_manager? : false
  end

  def curr_title_admin_header
    curr_title = ""
    all_navs_admin.each{|nav| curr_title = nav[:title] if nav[:url] == "/#{params[:controller]}" }
    curr_title
  end

  def all_product_items_top
    ProductItem.new({api_key: session[:current_magazine]}).current_top
  end

  # Методы которые нужно изменить

  def user_signed_in?
    current_user.present?
  end

  def new_user_session_path
    "/users/sign_in"
  end

  def current_user
    @current_user
  end

end
