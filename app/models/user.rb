class User
  def initialize(hash)
    hash.each do |k,v|
      self.instance_variable_set("@#{k}", v.is_a?(Hash) ? Hashit.new(v) : v)
      self.class.send(:define_method, k, proc{self.instance_variable_get("@#{k}")})
      self.class.send(:define_method, "#{k}=", proc{|v| self.instance_variable_set("@#{k}", v)})
    end
  end

  def self.current_user(api_key)
    user = ApiHookahStock.users("", "/info", {user_key: api_key})
    user.present? ? new( user ) : nil
  end

  def self.auth(login, password)
    ApiHookahStock.users("", "/auth_user", {login: login, password: password}).to_sym
  end

  def self.registration(params)
    ApiHookahStock.users("", "/reg_user", params).to_sym
  end

  def current_price_item(item)
    if item.default_price.blank? && contact.present?
      find_contact_price = contact.find_contact_price(item)
      find_contact_price.present? ? find_contact_price["price"] : ((!contact.opt rescue true) ? item.product.current_price : item.product.current_price_opt)
    else
      item.default_price
    end
  end

  def contact
    contact_id.present? ? Contact.find(contact_id) : nil
  end
end