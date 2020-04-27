class Category
  def initialize(hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v.is_a?(Hash) ? Hashit.new(v) : v)
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
    end
  end

  def self.all(api_key=nil)
    ApiHookahStock.categories("", "", {api_key: api_key}).map{|category| new(category) }
  end

  def self.find(id, api_key=nil)
    new(ApiHookahStock.categories(id, "", {api_key: api_key}))
  end

  def products(api_key=nil)
    ApiHookahStock.categories(id, "/products", {api_key: api_key}).map{|prod| Product.new(prod)}
  end
end