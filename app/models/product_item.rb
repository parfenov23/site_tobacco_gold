class ProductItem
  def initialize(hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v.is_a?(Hash) ? Hashit.new(v) : v)
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
    end
  end

  def all
    ApiHookahStock.product_items("", "", {type: "all", api_key: (api_key rescue nil)})
  end

  def current_top
    ApiHookahStock.product_items("", "", {type: "top", api_key: (api_key rescue nil)}).map{|pi| self.class.new(pi)}
  end

  def self.find(id, api_key=nil, no_cach=false)
    t = no_cach ? "?t=#{Time.now.to_i}" : ""
    new(ApiHookahStock.product_items("", "/#{id}#{t}", {api_key: api_key}))
  end

  def product
    Product.find(product_id)
  end

  def where(*arg)
    ApiHookahStock.product_items("", "", {type: "where", where: arg.first.to_json, api_key: (api_key rescue nil)}).map{|pi| self.class.new(pi)}
    # all.select{|hs| hs.slice(*arg.last.keys) == arg.last}
  end

  def current_img
    default_img.to_s.scan("http").present? ? default_img : (default_img.present? ? (ApiHookahStock.url + "#{default_img}") : "/no_img_item.png")
  end

  def current_price(current_user=nil)
    current_user.present? ? current_user.current_price_item(self) : (default_price || product.current_price)
  end

  def all_present
    ApiHookahStock.product_items("", "", {type: "present", api_key: api_key}).map{|pi| self.class.new(pi)}
  end

  def transfer_to_json
    as_json({
      methods: [:current_img]
    })
  end
end