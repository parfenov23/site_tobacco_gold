class Company
  def initialize(hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v.is_a?(Hash) ? Hashit.new(v) : v)
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
    end
  end

  def self.current(api_key=nil)
    new(ApiHookahStock.company({api_key: api_key}))
  end

  def magazines(api_key=nil)
    ApiHookahStock.all_magazines({api_key: api_key})
  end
end