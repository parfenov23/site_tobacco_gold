class ApiHookahStock
  require 'mechanize'

  def self.product_items(id="", add_url="", params={})
    add_id = id.present? ? "/#{id}" : ""
    sender(url + "/api/product_items#{add_id}#{add_url}", params)
  end

  def self.categories(id="", add_url="", params={})
    add_id = id.present? ? "/#{id}" : ""
    sender(url + "/api/categories#{add_id}#{add_url}", params)
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

  def self.company(params={})
    sender(url + "/api/api/company", params)
  end

  def self.all_magazines(params={})
    sender(url + "/api/api/all_magazines", params)
  end

  def self.all_content_pages(params={})
    sender(url + "/api/api/all_content_pages", params)
  end

  def self.all_top_magazine(params={})
    sender(url + "/api/api/all_top_magazine", params)
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
    Rails.env.production? ? "8605e5850d938c7ddb319760909524b2" : "b093dec6d556b53c69ff6e33a7b7d794"
  end
end