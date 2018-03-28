class ProductItem
  def initialize(hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v.is_a?(Hash) ? Hashit.new(v) : v)
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
    end
  end

  def self.all
    ApiHookahStock.product_items("", "", {type: "all"})
  end

  def self.top
    ApiHookahStock.product_items("", "", {type: "top"}).map{|pi| new(pi)}
  end

  def self.find(id)
    new(ApiHookahStock.product_items("", "/#{id}"))
  end

  def product
    Product.find(product_id)
  end

  def self.where(*arg)
    ApiHookahStock.product_items("", "", {type: "where", where: arg.first.to_json}).map{|pi| new(pi)}
    # all.select{|hs| hs.slice(*arg.last.keys) == arg.last}
  end

  def current_img
    default_img.to_s.scan("http").present? ? default_img : ApiHookahStock.url + "/#{default_img}"
  end

  def self.all_present
    ApiHookahStock.product_items("", "", {type: "present"}).map{|pi| new(pi)}
  end
end