class VkMessage
  def self.sender(message, type, captcha_arr=[], get_params)
    agent = Mechanize.new
    params_get = params(type).merge({message: message}).merge(get_params)
    params_get.merge!({captcha_sid: captcha_arr.first, captcha_key: captcha_arr.last}) if captcha_arr.present?
    response = JSON.parse(agent.post("https://api.vk.com/method/messages.send", params_get).body)
    return_status = {status: true, code: "ok"}
    if response["error"].present?
      if response["error"]["error_code"] == 14
        code_captcha = anticaptcha(response["error"]["captcha_img"])
        sender(message, type, [response["error"]["captcha_sid"],code_captcha.last], get_params)
      else
        return_status = {status: false, code: response["error"]["error_code"]}
      end
    end
    return return_status
  end

  def self.run(message, type="user", get_params={})
    Thread.new { sender(message, type, get_params) }
  end

  def self.params(type)
    case type
    when "user"
      {
        # access_token: "6752b799a52769e374f51deb9e549b75a0bfdebcd18a06b6e8669a2bea5899e2db697eb54a12aef5e4b2e",
        chat_id: "1"
      }
    when "group"
      {
        access_token: "d2e5220ce29d44a450ccd93db9c38d95e6860c1e7f0fbbd059cb308eaf59e7668a0b9f798ff647ea71ab2",
      }
    when "user_bot"
      {
        access_token: "0f9e712a6c26480f9d1580742ae6dd7a147a58243e1bf5053c34f876ad4f43d43982cc6195bd9ecfb7ed3",
      }
    end
  end

  def callback(get_params)
    case get_params[:type]
    when "message_new"
      message_price(get_params[:object])
    end
  end

  def self.all_users_dialog_group
    agent = Mechanize.new
    response = JSON.parse(agent.get("https://api.vk.com/method/messages.getDialogs", params("group").merge({count: 200})).body)
    arr = response["response"].drop(1)
    user_ids = arr.map{|a| a["uid"]}
    JSON.parse(agent.get("https://api.vk.com/method/users.get", 
      params("user").merge({user_ids: user_ids.join(","), fields: "can_write_private_message"})).body)["response"].map{|user| user["uid"] if user["can_write_private_message"] == 1}.compact
  end

  def self.message_price(get_params)
    get_params[:object].delete(:date)
    get_params = {type: get_params[:type], object: get_params[:object]}
    unless HistoryVk.where(params_type: get_params.to_s).present?
      body_text = (get_params[:object][:body].mb_chars.downcase.to_s) rescue nil
      if body_text == "прайс"
        message = Product.all.map{|product| "#{product.title}: #{product.current_price} рублей"}.join("\n")
        run(message, type="group", {user_id: get_params[:object][:user_id]})
      elsif body_text == "акция"
        message = Magazine.find(1).special_offer
        run(message, type="group", {user_id: get_params[:object][:user_id]})
      elsif body_text.scan("прайс").blank? 
        message = "Новое сообщение в группе\nПользователь: http://vk.com/id#{get_params[:object][:user_id]}\nСообщение: #{body_text}"
        run(message, type="user", {chat_id: '72'})
      end
      HistoryVk.create(params_type: get_params.to_s)
    end
  end

  def self.anticaptcha(url)
    captcha = Antigate.wrapper('80254ffdc4d2f1fc99f46c92019252f9')
    recognized = captcha.recognize(url, 'jpg')
    recognized
  end
end