class Contact
  def initialize(hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v.is_a?(Hash) ? Hashit.new(v) : v)
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
    end
  end

  def self.find(id)
    new( ApiHookahStock.contacts("", "/#{id}") )
  end

  def find_contact_price(item)
    all_contact_prices.select{|k| k["product_id"] == item.product_id}.last
  end

  def all_order_request
    ApiHookahStock.order_request("", "/contact_order_request", {contact_id: id})
  end

  def sales
    Sale.all_contact(id)
  end
end