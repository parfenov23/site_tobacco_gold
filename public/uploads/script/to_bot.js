$(window).resize(function() {
    if($(".open_right_aside").hasClass("close") && $(window).width() < 900){
        var content = $(".content__wrp .inner__right-sidebar");
        var right_aside = $("#right-sidebar");
        $(".open_right_aside").removeClass("close").addClass("open");
        right_aside.animate({
            left: parseInt( right_aside.css("left") ) + right_aside.width() + 300
        },function(){
            $(".right-sidebar__wrp").css("display", "none");
            var left_css_aside = parseInt( right_aside.css("left") ) - right_aside.width();
            right_aside.css("left", left_css_aside);
        });

        content.animate({
            left: 0
        },function(){
            content.css("position", "");
        });

    }
});
$(".open_right_aside").click(function(){
    if ($(this).hasClass("open") ){
        var content = $(".content__wrp .inner__right-sidebar");
        var left_css_content = "-"+content.width()+"px";
        var right_aside = $("#right-sidebar");
        $(".right-sidebar__wrp").css("display", "block");
        var left_css_aside = parseInt( right_aside.css("left") ) + right_aside.width();
        right_aside.css("left", left_css_aside);
        right_aside.animate({
            left: parseInt( right_aside.css("left") ) - right_aside.width() - 300
        }, 500, function(){
            $("aside#right-sidebar").css("height", "")
        });
        content.css("position", "relative");
        content.animate({
            left: left_css_content
        }, 500);
        if($("aside#right-sidebar").height() > $(window).height()){
            $("aside#right-sidebar").css("cssText", "position: absolute !important;");
        }
    }
    if ($(this).hasClass("close") ){
        var content = $(".content__wrp .inner__right-sidebar");
        var right_aside = $("#right-sidebar");

        right_aside.animate({
            left: parseInt( right_aside.css("left") ) + right_aside.width() + 300
        },function(){
            $(".right-sidebar__wrp").css("display", "none");
            var left_css_aside = parseInt( right_aside.css("left") ) - right_aside.width();
            right_aside.css("left", left_css_aside);
        });

        content.animate({
            left: 0
        },function(){
            content.css("position", "");
        });

    }
    $(this).toggleClass("open").toggleClass("close");

});