class ApiHookahStock
  require 'mechanize'

  def self.product_items(id="", add_url="", params={})
    add_id = id.present? ? "/#{id}" : ""
    # p "================== test ====================================="
    sender(url + "/api/product_items#{add_id}#{add_url}", params)
  end

  def self.categories(id="", add_url="")
    add_id = id.present? ? "/#{id}" : ""
    sender(url + "/api/categories#{add_id}#{add_url}")
  end

  def self.products(id="", add_url="")
    add_id = id.present? ? "/#{id}" : ""
    sender(url + "/api/products#{add_id}#{add_url}")
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

  def self.sender(url, params={}, type="get")
    time_hash = Rails.env.production? ? 5 : 0
    Rails.cache.fetch(url + "?" + params.to_query, expires_in: time_hash.minute) do
      agent = Mechanize.new
      params.merge!({api_key: api_key})
      page = (type == "get" ? agent.get(url, params) : agent.post(url, params))
      JSON.parse(page.body)
    end
  end

  def self.url
    Rails.env.production? ? "http://hookah-stock.ru" : "http://localhost:3000"
  end

  def self.api_key
    Rails.env.production? ? "22ef8fcbc747007dbf878c2bcad6c9cf" : "3581226b0abdac4ab82d3fa6cf3ef088"
  end
end