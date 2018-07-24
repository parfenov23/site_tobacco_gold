class ApiHookahStock
  require 'mechanize'

  def self.product_items(id="", add_url="", params={})
    add_id = id.present? ? "/#{id}" : ""
    sender(url + "/api/product_items#{add_id}#{add_url}", params)
  end

  def self.categories(id="", add_url="")
    add_id = id.present? ? "/#{id}" : ""
    sender(url + "/api/categories#{add_id}#{add_url}")
  end

  def self.products(id="", add_url="", params={})
    add_id = id.present? ? "/#{id}" : ""
    sender(url + "/api/products#{add_id}#{add_url}", params)
  end

  def self.users(id="", add_url="", params={})
    add_id = id.present? ? "/#{id}" : ""
    sender(url + "/api/users#{add_id}#{add_url}", params)
  end

  def self.contacts(id="", add_url="", params={})
    add_id = id.present? ? "/#{id}" : ""
    sender(url + "/api/contacts#{add_id}#{add_url}", params)
  end

  def self.order_request(id="", add_url="", params={}, type="get")
    add_id = id.present? ? "/#{id}" : ""
    sender(url + "/api/order_requests#{add_id}#{add_url}", params, type)
  end

  def self.sales(id="", add_url="", params={})
    add_id = id.present? ? "/#{id}" : ""
    sender(url + "/api/sales#{add_id}#{add_url}", params)
  end

  def self.company
    sender(url + "/api/api/company")
  end

  def self.all_magazines
    sender(url + "/api/api/all_magazines")
  end

  def self.sender(url, params={}, type="get")
    time_hash = Rails.env.production? ? 5 : 0
    Rails.cache.fetch(url + "?" + params.to_query, expires_in: time_hash.minute) do
      agent = Mechanize.new
      params.merge!({api_key: api_key}) if params[:api_key].blank?
      page = (type == "get" ? agent.get(url, params) : agent.post(url, params))
      JSON.parse(page.body)
    end
  end

  def self.url
    Rails.env.production? ? "http://hookah-stock.ru" : "http://localhost:3000"
  end

  def self.api_key
    Rails.env.production? ? "d2e5220ce29d44a450ccd93db9c38d95e6860c1e7f0fbbd059cb308eaf59e7668a0b9f798ff647ea71ab2" : "d2e5220ce29d44a450ccd93db9c38d95e6860c1e7f0fbbd059cb308eaf59e7668a0b9f798ff647ea71ab2"
  end
end