class Array
  def find_id(id)
    select{|h|  h.to_sym.select{|k, v| (k == :id && v.to_i == id.to_i)} == {:id => id.to_i}}.last
  end
end

class Hash
  def to_sym
    inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}
  end
end