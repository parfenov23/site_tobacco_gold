function show_category(){
    var block = $(".category_sidebar.open_category");
    var block_less = $(".category_sidebar_less.open_category");
    if (block.length > 0){
        var category_block = $("#category");
        var category_width = category_block.width();
        category_block.animate({
            left: (category_width * (- 1))
        });
        block.removeClass("open_category");

    }
    if (block_less.length > 0){
        var category_block = $("#category");
        var category_height = category_block.height();
        category_block.animate({
            top: (category_height * (- 1))
        });
        block_less.removeClass("open_category");

    }
}
$(document).ready(function(){
    //$("html").click(function(){
    //    if ($(this).hasClass("for-hover") != true){
    //        show_category();
    //    }
    //});

    $(".category_sidebar").click(function () {
        var category_block = $("#category");
        var category_width = category_block.width();
        var type = $(this).data("type");
        var left_bar_width = $("#left-sidebar-" + type).width();
        var triangle_width = $(".triangle-left").width();
        var triangle_top = $(this).position().top + ($(this).height() / 2);
        category_block.css("top", $("header").css("height"));
        category_block.find(".triangle-left").css("margin-top", triangle_top);
        if ($(this).hasClass("open_category") != true){
            category_block.animate({
                left: left_bar_width + triangle_width
            });

            $(this).addClass("open_category");
        } else {
            category_block.animate({
                left: (category_width * (- 1))
            });
            $(this).removeClass("open_category");
        }

        return true;
    });

    $(window).resize(function () {
        show_category();
    });

    $(".category_sidebar_less").click(function () {
        var category_block = $("#category");
        var category_height = category_block.height();
        if ($(this).hasClass("open_category") != true){
            category_block.css("top", category_height * (- 1));
            category_block.css("left", "0");
            var block_top = $("header").height() + $("#two_top-sidebar-less").height();
            category_block.animate({
                top: block_top
            });
            $(this).addClass("open_category");
        } else {
            var block_top = category_height * (- 1);
            category_block.animate({
                top: block_top
            });
            $(this).removeClass("open_category");
        }


    });
});