var addCountToBasket = function(){
  var btn_id = $(this).data('id');
  var count = $(this).closest(".parent_item").find(".js__countItemBasket").val();
  $.ajax({
    type   : 'POST',
    url    : '/add_item_to_basket',
    data   : {item_id: btn_id, count: count},
    success: function (data) {
      show_error('Товар добавлен в корзину', 3000);
      $("header .my_rate .count").show();
      $("header .my_rate .count").text(data.count);
    },
    error  : function () {
      show_error('Ошибка', 3000);
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
      $(".header_block .js__titleTotlaPriceBasket").text(data.total_price + " руб")
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
    input.val(count+1);
  }
  if(btn.data("type") == "rm"){
    input.val(count-1);
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


$(document).ready(function () {
  $(document).on('click', '.js__addToBasket', addCountToBasket);
  $(document).on('click', '.js__rmItemInBasket', rmItemInBasket);
  $(document).on('click', '.js__addCountItemBasket', addCountItemBasket);
  $(document).on('click', '.js__submitFormBasket', submitFormBasket);

  $(".form_send_basket [name='request[user_phone]']").mask("+7(999) 999-9999");
});