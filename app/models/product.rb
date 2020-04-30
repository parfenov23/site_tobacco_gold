class Product
  def initialize(hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v.is_a?(Hash) ? Hashit.new(v) : v)
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
    end
  end

  def self.all(api_key=nil)
    ApiHookahStock.products("", "", {api_key: api_key}).map{|product| new(product)}
  end

  def find(id)
    self.class.new(ApiHookahStock.products(id))
  end

  def product_items(api_key=nil)
    ApiHookahStock.products(id, "/product_items", {api_key: api_key}).map{|pi| ProductItem.new(pi)}
  end

  def find_product_items_by_tag(tag_id)
    ApiHookahStock.products(id, "/tag_product_items", {api_key: api_key, tag_id: tag_id}).map{|pi| ProductItem.new(pi)}
  end

  def current_image
    default_img.present? ? default_img : "/no_img_item.png"
  end
end