class Sale
  def initialize(hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v.is_a?(Hash) ? Hashit.new(v) : v)
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
    end
  end

  # def self.find(id)
  #   new( ApiHookahStock.contacts("", "/#{id}") )
  # end

  def self.all_contact(contact_id)
    ApiHookahStock.sales("", "/all_contact", {contact_id: contact_id}).map{|sale| new sale}
  end

  def sale_items
    ApiHookahStock.sales("#{id}", "/sale_items", {}).map{|sale_item| SaleItem.new sale_item}
  end
end