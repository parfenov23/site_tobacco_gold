//$(document).ready(function () {
//    var $block_info = $("#info_point"),
//        $window = $(window),
//        $header = $("header"),
//        header_height = $header.height(),
//        block_info_top = $block_info.position().top;
//
//    $window.scroll(function (event) {
//        var st = $(this).scrollTop(),
//            fix_position = (block_info_top-header_height),
//            content = $(".content"),
//            max_scroll = content.position().top + content.height() - $block_info.height() - 40;
//        if ((st >= fix_position) && (st - header_height - 20 <= max_scroll) ){
//            $block_info.css("margin-top", 0);
//            $block_info.addClass("fix_top");
//            $block_info.removeClass("fix_content");
//        }
//        if (st <= fix_position){
//            $block_info.css("margin-top", 0);
//            $block_info.removeClass("fix_top");
//            $block_info.removeClass("fix_content");
//        }
//        if ((st-header_height - 20 >= max_scroll) ){
//            if(!$block_info.hasClass("fix_content")){
//                $block_info.css("margin-top", st-header_height - 20);
//                $block_info.removeClass("fix_top");
//                $block_info.addClass("fix_content");
//            }
//        }
//
//        //if ((st-header_height - 20 <= max_scroll) && ) {
//        //    $block_info.removeClass("fix_content");
//        //    $block_info.addClass("fix_top");
//        //}
//
//    });
//});