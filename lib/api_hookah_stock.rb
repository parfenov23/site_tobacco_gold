class ApiHookahStock
  require 'mechanize'
  require 'digest/md5'

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

  def self.contacts(id="", add_url="", params={}, type="get")
    add_id = id.present? ? "/#{id}" : ""
    sender(url + "/api/contacts#{add_id}#{add_url}", params, type)
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

  def self.find_api_key(params={})
    sender(url + "/api/api/find_api_key", params)
  end

  def self.sender(url, params={}, type="get")
    time_hash = Rails.env.production? ? 5 : 0
    id_cache = Digest::MD5.hexdigest(url + "?" + params.to_query)
    begin
      Rails.cache.fetch(id_cache, expires_in: time_hash.minute, race_condition_ttl: time_hash.minute) do
        # FileUtils.rm_rf(Rails.root.to_s + "/tmp/cache")
        agent = Mechanize.new
        params.merge!({api_key: api_key}) if params[:api_key].blank?
        page = sender_method(agent, type, url, params)
        # FileUtils.rm_rf(Rails.root.to_s + "/tmp/cache")
        JSON.parse(page.body)
      end
    rescue Errno::EACCES => e
      FileUtils.rm_rf(Rails.root.to_s + "/tmp/cache")
      sender(url, params={}, type="get")
    end

  end

  def self.sender_method(agent, type, url, params)
    case type
    when "get"
      agent.get(url, params)
    when "post"
      agent.post(url, params)
    when "put"
      agent.put(url, params.to_json, {"Content-Type" => "application/json"})
    end
  end

  def self.url
    Rails.env.production? ? "https://crm-stock.ru" : "http://localhost:3000"
  end

  def self.api_key
    Rails.env.production? ? "8605e5850d938c7ddb319760909524b2" : "b093dec6d556b53c69ff6e33a7b7d794"
  end
end