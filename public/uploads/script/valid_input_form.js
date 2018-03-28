function all_valid_inputs() {
  var ipnuts = $('.form_validate input').not(".no_valid");
  var count_valid_input = 0;
  // $("#user_email").focus();
  $.each(ipnuts, function (i, tag) {
    if (valid_input(tag)){
      count_valid_input += 1
    }
  });
  if (ipnuts.length == count_valid_input){
    $(".form_validate .action_btn .submit_form").removeClass('disabled');
  } else {
    $(".form_validate .action_btn .submit_form").addClass('disabled');
  }
}
function valid_input(e) {
  var result = false;
  if ($(e).val().length > 0 && !$(e).hasClass("no_valid")){
    result = true;
    if ($(e).attr("type") == "email"){
      var pattern = /^([a-z0-9_\.-])+@[a-z0-9-]+\.([a-z]{2,4}\.)?[a-z]{2,4}$/i;
      if (pattern.test($(e).val())){
        result = true;
      } else {
        result = false;
      }
    }
  } else {
    result = false;
  }
  return result;
}
$(document).ready(function () {
  all_valid_inputs();
  $('.form_validate input').on('keyup paste input propertychange', function () {
    all_valid_inputs();
  });

  $(".form_validate .action_btn .submit_form").click(function () {
    if (! $(this).hasClass("disabled")){
      $(this).closest(".action_btn").find("input[type=submit]").click();
    }
  });

  $(document).on('click','form#auth_user input[type="submit"]', function(e){
    e.preventDefault();
    $.ajax({
      type   : 'POST',
      url    : '/users/auth',
      data   : $("form").serialize(),
      success: function (data) {
        if(data.success){
          window.location.href = "/"
        }else{
          show_error("Проверьте логин или пароль", 3000);
        }
        
      },
      error  : function () {
        show_error('Ошибка', 3000);
      }
    });
  });
  $(document).on('click','form#new_user input[type="submit"]', function(e){
    e.preventDefault();
    $.ajax({
      type   : 'POST',
      url    : '/users/registration',
      data   : $("form").serialize(),
      success: function (data) {
        if(data.success){
          window.location.href = "/"
        }else{
          show_error("Проверьте данные", 3000);
        }
        
      },
      error  : function () {
        show_error('Ошибка', 3000);
      }
    });
  });
});