class Product
  def initialize(hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v.is_a?(Hash) ? Hashit.new(v) : v)
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
    end
  end

  def self.all
    ApiHookahStock.products.map{|product| new(product)}
  end

  def find(id)
    self.class.new(ApiHookahStock.products(id))
  end

  def product_items(api_key)
    ApiHookahStock.products(id, "/product_items", {api_key: (api_key rescue nil)}).map{|pi| ProductItem.new(pi)}
  end
end