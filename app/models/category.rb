class Category
  def initialize(hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v.is_a?(Hash) ? Hashit.new(v) : v)
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
    end
  end

  def self.all
    ApiHookahStock.categories.map{|category| new(category) }
  end

  def self.find(id)
    new(ApiHookahStock.categories(id))
  end

  def products
    ApiHookahStock.categories(id, "/products").map{|prod| Product.new(prod)}
  end
end