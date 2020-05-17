updateUserContact = function(){
  var btn = $(this);
  var form = btn.closest("form");
  $.ajax({
    type   : 'POST',
    url    : '/update_user_contact',
    data   : form.serialize(),
    success: function (data) {
      show_error('Информация обновлена', 3000);
    },
    error  : function () {
      show_error('Ошибка', 3000);
    }
  });
}

$(document).ready(function(){
  $(document).on('click', '.js_updateUserContact', updateUserContact);
  $("form.user_info input[name='contact[phone]']").mask("+7(999) 999-9999");
});