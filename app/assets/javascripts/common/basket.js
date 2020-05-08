var addCountToBasket = function(){
  var btn_id = $(this).data('id');
  var count = $(this).closest(".parent_item").find(".js__countItemBasket").val();
  var max_count = parseInt($(this).closest(".parent_item").find(".title_count").data("max_count"));
  $.ajax({
    type   : 'POST',
    url    : '/add_item_to_basket',
    data   : {item_id: btn_id, count: count, max_count: max_count},
    success: function (data) {
      show_error('Товар добавлен в корзину', 3000);
      $("header .my_rate .count").show();
      $("header .my_rate .count").text(data.count);
    },
    error  : function () {
      show_error('Ошибка. Попробуйте уменьшить количество', 3000);
    }
  });
}

var rmItemInBasket = function(){
  var btn = $(this);
  var btn_id = $(this).data('id');
  $.ajax({
    type   : 'POST',
    url    : '/rm_item_to_basket',
    data   : {item_id: btn_id},
    success: function (data) {
      show_error('Товар удален из корзины', 3000);
      $("header .my_rate .count").text(data.length);
      $(".header_block .js__titleTotlaPriceBasket").text(data.total_price.toFixed(1) + " руб")
      btn.closest(".item_content").remove();
    },
    error  : function () {
      show_error('Ошибка', 3000);
    }
  });
}

var addCountItemBasket = function(){
  var btn = $(this);
  var input = btn.closest(".title_count").find("input");
  var count = parseInt(input.val());
  if(btn.data("type") == "add"){
    count += 1;
    input.val(count);
  }
  if(btn.data("type") == "rm"){
    count -= 1;
    input.val(count);
  }
  var max_count = parseInt($(btn).closest(".title_count").data("max_count"));
  var curr_count = parseInt($(btn).closest(".title_count").data("current_count"));
  if (count == (max_count - curr_count)){
    $(btn).closest(".title_count").find("[data-type='add']").hide();
  }else{
    $(btn).closest(".title_count").find("[data-type='add']").show();
  }
}

var submitFormBasket = function(){
  var form = $(this).closest("form");
  var name = form.find("[name='request[user_name]']").val();
  var phone = form.find("[name='request[user_phone]']").val();
  var street = form.find("[name='request[address][street]']").val();
  var house = form.find("[name='request[address][house]']").val();
  var room = form.find("[name='request[address][room]']").val();
  var type_payment = form.find("[name='request[type_payment]']").val();
  var valid_type_payment = (type_payment == "cash" || type_payment == "visa");
  var min_price_order = parseInt(form.find(".minPriceOrder").val());
  var valid_min_price_order = (parseFloat($(".js__titleTotlaPriceBasket").text()) >= min_price_order);

  if ((form.find("[name='contact_id']").length || name.length && phone.length) && (street.length && house.length && room.length && valid_type_payment && valid_min_price_order)){
    $.ajax({
      type   : 'POST',
      url    : '/send_item_to_basket',
      data   : form.serialize(),
      success: function (data) {
        show_error('Ваша заявка отправлена. Наш менеджер свяжется с Вами в ближайшее время!', 3000);
        setTimeout(function(){
          window.location.href = '/'
        }, 3000)
      },
      error  : function () {
        show_error('Ошибка', 3000);
      }
    });
  }else{
    if(!valid_min_price_order){
      show_error('Минимальная сумма заказа '+min_price_order+" руб.", 3000);
    }else{
      show_error('Пожалуйста заполните все поля', 3000);
    }
  }
}

var sum_basket = function(){
  var sum = 0;
  $(".content_rate .item_content").each(function(n, block){
    var price = parseFloat($(block).find(".sum").text());
    var count = parseFloat($(block).find(".count span").text());
    sum += (price*count);
  });
  sum = sum + price_delivery(sum);
  $(".header_block .sum_price").text(sum + " руб");
  var min_price_order = parseInt($(".form_send_basket .minPriceOrder").val());
  if(sum > min_price_order){
    $(".form_send_basket .btn").show();
    $(".form_send_basket .min_price_order").hide();
  }else{
    $(".form_send_basket .btn").hide();
    $(".form_send_basket .min_price_order").show();
  }
}

var price_delivery = function(sum){
  var all_delivery = $(".content_rate").data("delivery").split(";");
  last_price = 0;
  $.each(all_delivery, function(n, v){
    if(v != ""){
      var delivery = v.split("=");
      var min_price = parseInt(delivery[0]);
      var price = parseInt(delivery[1]);
      if (sum >= min_price){
        last_price = price;
      }
    }
  });
  if(last_price > 0){
    $(".content_rate .delivery").show();
    $(".content_rate .delivery .price").text(last_price + " руб");
  }else{
    $(".content_rate .delivery").hide();
  }
  return last_price;
}

var addOrRmCountBasket = function(){
  var btn = $(this);
  var btn_id = btn.data('id');
  var type = btn.data('type');
  $.ajax({
    type   : 'POST',
    url    : '/add_or_rm_count_item_basket',
    data   : {item_id: btn_id, type: type},
    success: function (data) {
      btn.closest(".count").find("span").text(data.count + " шт.");
      sum_basket();
      var max_count = parseInt(btn.closest(".count").data("max_count"));
      if(data.count == max_count){
        btn.closest(".count").find(".btn_increase[data-type='add']").hide();
      }else{
        btn.closest(".count").find(".btn_increase[data-type='add']").show();
      }
      if(data.count == 0){
        btn.closest(".item_content").find(".js__rmItemInBasket").click();
      }
    },
    error  : function () {
      show_error('Ошибка', 3000);
    }
  });
}


$(document).ready(function () {
  $(document).on('click', '.js__addToBasket', addCountToBasket);
  $(document).on('click', '.js__rmItemInBasket', rmItemInBasket);
  $(document).on('click', '.js__addCountItemBasket', addCountItemBasket);
  $(document).on('click', '.js__submitFormBasket', submitFormBasket);
  $(document).on('click', '.js__AddOrRmCountBasket', addOrRmCountBasket);

  $(".form_send_basket [name='request[user_phone]']").mask("+7(999) 999-9999");
});