/*global $:false */



$(document).ready(function () {
    "use strict";
    var contentHeight = ($('.content-wrp .top-5-content').height() + 20);
    $('.content-wrp').css('height', contentHeight + 'px');


    $('.tabs .top-5, .tabs .bonuses').on('click', function (event) {
        if ($(this).hasClass('active')){
        } else {
            var posX = ($(this).position().left) + ($(this).innerWidth()) / 2,
                currTabs = $(this);
            $(this).closest('.tabs').find('.arrow').animate({
                left: posX + 'px'
            }, 700, 'easeInOutCirc', function () {
                currTabs.addClass('active');
            });
            $('.tabs .top-5, .tabs .bonuses').removeClass('active');
            if ($(this).index() === 0){
                $('.bonuses-content').removeClass('static');
                contentHeight = $('.content-wrp .top-5-content').height();
                $('.content-wrp').css({
                    height   : contentHeight + 'px',
                    minHeight: contentHeight + 'px'
                });

                $('.top-5-content').animate({
                    left: '-3px'
                }, 700, 'easeOutQuint', function () {
                    $('.content-wrp').css('height', contentHeight + 'px')
                });
                $('.bonuses-content').animate({
                    left: '300px'
                }, 700, 'easeOutQuint');
            } else if ($(this).index() === 1){
                contentHeight = $('.content-wrp .bonuses-content').height();
                $('.content-wrp').animate({
                    height: contentHeight + 'px'
                }, 700, 'easeOutQuint');

                $('.top-5-content').animate({
                    left: '-350px'
                }, 700, 'easeOutQuint');

                $('.bonuses-content').animate({
                    left: '0'
                }, 700, 'easeOutQuint', function () {
                    $('.content-wrp').css({
                        minHeight: contentHeight + 'px',
                        height   : 'auto'
                    });
                    $('.bonuses-content').addClass('static');
                });


            }
        }
    });


    $('aside .bonuses-content .item .social-activity a.comments').on('click', function (e) {
        var itemBlock = $(this).closest('.item');
        itemBlock.find('.comments-list').slideToggle(700, 'easeInOutCirc', function () {
            if ($(this).css('display') != 'block'){
                $(this).closest('.item').find('.social-activity').removeClass('active');
            } else {
                $(this).closest('.item').find('.social-activity').addClass('active');
            }
        });
        itemBlock.find('.battle-area').hide(700, 'easeInOutCirc');

    });


    $('aside .bonuses-content .item .social-activity a.battle, aside .bonuses-content .item .social-activity a.comments').on('click', function (e) {
        $(this).parent().addClass('active');

    });


});
