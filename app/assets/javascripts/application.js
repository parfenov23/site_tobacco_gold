//= require_tree ./vendor
//= require_tree ./common

show_error = function (text, duration) {
  var el = $('#alert');
  el.find('.text').text(text);
  el.show(300);
  el.find('.close').click(function () {
    el.hide(400);
  });
  if (duration){
    setTimeout(function () {
      el.hide(400);
    }, duration);
  }
};

show_error_popup = function (text) {
  $("#overlay, .alert_popup").show();
  $(".alert_popup .text").html(text);
}

close_error_popup = function(){
  $("#overlay, .alert_popup").hide();
  window.location.reload();
}

function hide_to_top() {
  var scrollHeight = $(document).scrollTop();
  var windowHeight = $(window).height();
  if (scrollHeight > (windowHeight / 2)){
    $('#to-top').fadeIn(500);
    $('#to-top a').fadeIn(500);
  } else {
    $('#to-top').fadeOut(500);
    $('#to-top a').fadeOut(500);

  }
}

var noUIinstall = function(){
  if ($("#sliderSort").length){
    var slider = document.getElementById('sliderSort');
    var price_from = parseInt($(slider).data("from"));
    var price_to = parseInt($(slider).data("to"));
    noUiSlider.create(slider, {
      start: [price_from, price_to],
      connect: true,
      tooltips: true,
      format: 
      {
        to: function (value) {
          return Math.round(value) + ' Руб.';
        },
        from: function (value) {
          return value.replace('Руб.', '');
        }
      },
      range: {
        'min': 0,
        'max': 1000
      }
    });
  }
}

var get_url_params_to_hash = function (hash){
  var pathname = window.location.pathname
  var array_urls = window.location.href.split("?")
  var all_params = ""
  if (array_urls.length > 1){
    all_params = array_urls[1].split("&")
  }
  var all_params_hash = {}
  $.each(all_params, function(k, v){
    var arr_p = v.split("=");
    all_params_hash[arr_p[0]] = arr_p[1]
  });
  var merge_params = $.extend(all_params_hash, hash);
  var all_merge_params = []
  $.each(merge_params, function(k, v){ all_merge_params.push(k + "=" + v) });
  return pathname + "?" + all_merge_params.join("&");
}

$(document).scroll(function () {
  hide_to_top()
});

$(document).on('click', 'header .address .currAddress', function(){
  $(this).closest(".address").find("ul").show();
});

$(document).on('click', 'body', function(e){
  var block = $(e.target);
  if(!block.closest(".address").length){
    $(".listGroupAddress").hide();
  }
});

var loadDataImg = function(){
  [].forEach.call(document.querySelectorAll('img[data-src]'), function(img) {
    img.setAttribute('src', img.getAttribute('data-src'));
    img.onload = function() {
      img.removeAttribute('data-src');
    };
  });
}

var insertParam = function(key, value){
    key = encodeURI(key); value = encodeURI(value);
    var kvp = document.location.search.substr(1).split('&');
    var i=kvp.length; var x; 
    while(i--) {
        x = kvp[i].split('=');
        if (x[0]==key){
            x[1] = value;
            kvp[i] = x.join('=');
            break;
        }
    }
    if(i<0) {kvp[kvp.length] = [key,value].join('=');}
    document.location.search = kvp.join('&'); 
}

$(document).ready(function () {
  hide_to_top();
  $('#to-top a').on('click', function (e) {
    event.preventDefault();
    $('html, body').stop()
    .animate({scrollTop: '0'}, 500);
    e.preventDefault();
  });

  $(document).on('click', '.js__openLeftSideBarMenu', function(){
    if ($(this).hasClass('active')){
      $("section.left-sidebar__wrp aside").css({left: "-100%"});
    }else{
      $("section.left-sidebar__wrp aside").css({left: "0"});
    }
    $( this ).toggleClass( "active" );
  });

  //
  $(".js_selectOrderItems").change(function(){
    insertParam("sort", $(this).val());
});

  $(document).on('click', '.js__submitBtnFormSliderSort', function(){
    var block_sort = $(this).closest(".sorting_slider").find("#sliderSort");
    var from = block_sort.find(".noUi-handle-lower .noUi-tooltip").text().split(" Руб.")[0];
    var to = block_sort.find(".noUi-handle-upper .noUi-tooltip").text().split(" Руб.")[0];
    window.location.href = get_url_params_to_hash({"price[from]": from, "price[to]": to})
  });
  noUIinstall();
  loadDataImg();

  $(document).on('click', '.alert_popup .close', close_error_popup);

  $(document).on('click', '.js_loadContentPage', function(){
    var btn = $(this).closest(".js_loadContentPage");
    var url = btn.data("href");
    history.pushState(url, "Категории", url);
    $.ajax({
      type   : 'get',
      url    : url,
      data   : {type: 'json'},
      success: function (data) {
        var content = $(data);
        $("#content").fadeOut(300, function(){
          $("#content").html('');
          $("#content").append(content);
          $("#content").fadeIn(300);
          loadDataImg();
        });
      },
      error  : function () {
        show_error('Ошибка', 3000);
      }
    });
  })

});
