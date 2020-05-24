$(document).ready(function(){
  var timout_search_keyup = ""
  $(document).on('keyup', '.js_search_product_item', function(){
    clearTimeout(timout_search_keyup);
    var input = $(this);
    var search_list_block = $(".search .listWrpSearch");
    if(input.val().length > 0){
      timout_search_keyup = setTimeout(function(){
        $.ajax({
          type   : 'GET',
          url    : '/ajax_search_product_item',
          data   : {search: input.val()},
          success: function (data) {
            search_list_block.find(".cloneRefer").remove();
            search_list_block.show();
            if(data.length > 0){
              var ref_block = search_list_block.find(".reference");
              $.each(data, function(n, e){
                var clone_ref_block = ref_block.clone();
                clone_ref_block.find("a").attr("href", "/item/"+e.id);
                clone_ref_block.find("img").attr("src", e.current_img);
                clone_ref_block.find(".title").text(e.title);
                clone_ref_block.find(".price").text(e.default_price + " руб.")
                clone_ref_block.removeClass("reference").addClass("cloneRefer");
                ref_block.closest("ul").append(clone_ref_block);
              });
              search_list_block.find(".notSearch").hide();
            }else{
              search_list_block.find(".notSearch").show();
            }
          },
          error  : function () {
            show_error('Ошибка.', 3000);
          }
        });
      }, 500);
    }else{
      search_list_block.hide();
    }
  });

  $(document).on('click', '.js_search_product_item', function(){
    var list_search = $(".search .listWrpSearch");
    if (list_search.find(".cloneRefer").length > 0 && $(this).val().length > 0){
      list_search.show();
    }
  });

  $(document).on('click', 'html', function(e){
    var block = $(e.target);
    if(!block.closest(".search").length){
      $(".search .listWrpSearch").hide();
    }
  });
});