userResetPassword = function(){
  var btn = $(this);
  var form = btn.closest("form");
  $.ajax({
    type   : 'POST',
    url    : '/user_reset_password',
    data   : form.serialize(),
    success: function (data) {
      show_error(data.text, 3000);
      setTimeout(function(){
        window.location.href = '/sign_in'
      }, 3000);
    },
    error  : function () {
      show_error('Ошибка', 3000);
    }
  });
}

$(document).ready(function(){
  $(document).on('click', '.js_userResetPassword', userResetPassword);
});