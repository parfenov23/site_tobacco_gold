/*global $:false */
/*global document:false */
/*global window:false */
/*global console:false */


var changeToUpHeight = 0,
scrollUp = false,
scrollDown = true,
begin = true,
aside = $('aside#right-sidebar'),
topHeight = 0;
$(document).ready(function () {
  "use strict";
  var $aside = $("aside#right-sidebar"),
  $window = $(window),
  offset = $aside.offset(),
  action_block_aside = $(".time-countdown-wrp"),
  action_block_header = $('.header_action_block');

  if ( $window.scrollTop() > 7 ){
    $aside.addClass("fix-to-top");
  }

  var lastScroll = $(window).scrollTop(),
  valid_top_up = false,
  valid_top_down = true,
  top_up = 0,
  aside_top = 45;

  var remove_class = function(){
    $aside.removeClass("frozen");
    $aside.removeClass("fix-to-top");
    $aside.removeClass("fix-to-bottom");
  };
  $aside.css("left", $(".inner__right-sidebar").width()).css("position", "absolute");
  $(window).resize(function(){
    $aside.css("left", $(".inner__right-sidebar").width());
  });
  $window.scroll(function (event) {
    if ($aside.length){
      var top = $aside.position().top,
      st = $(this).scrollTop(),
      window_height = $(window).height() - aside_top - $("#to-top").height(),
      max_scroll = $("#content").height() - ($(window).height() - aside_top - $("#to-top").height());
      if (st > 0 && st < max_scroll && $aside.height() > window_height && $aside.height()+100 < $('#content').height()){
        if (st > lastScroll){
                // up
                if (valid_top_down){
                  if ($aside.hasClass("frozen") == false  ){
                    remove_class();
                    $aside.addClass("frozen");
                    top_up = st - $aside.height() + window_height + $aside.height() - window_height;
                    $aside.css("top", top_up);
                    valid_top_down = false;
                  }
                }
                if ($aside.height() - window_height + top_up + 10 <= st + aside_top + 25){


                  if ($aside.hasClass("fix-to-bottom") == false  ){
                    remove_class();
                    $aside.addClass("fix-to-bottom");
                    $aside.css("top", "auto");
                    valid_top_up = true;
                  }

                }
              } else {
                // down
                if (valid_top_up){
                  if ($aside.hasClass("frozen") == false  ){
                    remove_class();

                    $aside.addClass("frozen");

                    top_up = st - $aside.height() + window_height + aside_top + 10;
                    $aside.css("top", top_up);
                    valid_top_up = false;
                  }
                }
                if (st <= top){
                  if ($aside.hasClass("fix-to-top") == false  ){
                    remove_class();

                    $aside.addClass("fix-to-top");
                    $aside.css("top", "auto");

                    valid_top_down = true;
                  }
                }

              }

          }else{

            if (st < max_scroll){
              remove_class();
            }
            if ($aside.height() < window_height){
              if ($aside.hasClass("fix-to-top") == false  ){
                remove_class();
                $aside.addClass("fix-to-top");
                $aside.css("top", "auto");
              }
            }

          }

          lastScroll = st;

        }
      });


});
