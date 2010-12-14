$(window).load(function(){
   //Campaigns list

   //Height normalize
   $("div.Container div.ListRow div.LCol1").each(function(){
      $(this).parent().height($(this).height());
   });
   $("div.Container div.ListRow div.LCol24").each(function(){
      $(this).height($(this).parent().height());
   });
   $("div.Container div.ListRow div.LCol3_part").each(function(){
      $(this).height($(this).parent().height());
   });
   $("div.Container div.ListRow div.LCol5").each(function(){
      $(this).height($(this).parent().height());
   });
   $("div.Container div.ListRow div.LCol24 div").each(function(){
      $(this).height($(this).parent().height());
   });
   $("div.Container div.ListRow div.LCol3_part div").each(function(){
      $(this).height($(this).parent().height());
   });
   $("div.Container div.ListRow div.LCol5 div").each(function(){
      $(this).height($(this).parent().height());
   });
   //Light
   $("div.Container div.ListRow").mouseover(function(){
       $(this).css("background-color", "#EFEFEF");
   });
   $("div.Container div.ListRow").mouseout(function(){
       $(this).css("background-color", "#FFFFFF");
   });


   //Path

   var totalWidth = 0;
   var maxH = 0;
   $("div.Container div.Path div.Element").each(function(){
       maxH = Math.max(maxH, $(this).height());
   });
   $("div.Container div.Path div.Element").each(function(){
       $(this).height(maxH);
       $(this).parent().height(maxH);
   });
   $("div.Container div.Path div.Element div").each(function(){
       $(this).height(maxH);
       $(this).parent().width($(this).width());
       totalWidth += $(this).width();
   });
   $("div.Container div.Path div.Separator").each(function(){
       $(this).height(maxH);
       totalWidth += $(this).width()
   });
   $("div.Container div.Path div.Separator div").each(function(){
       $(this).height(maxH);
   });

    function recalc_balance_div_width()
    {
       $("div.Container div.BalanceContainer div").each(function(){
         $(this).parent().css("left", 1024-$(this).width() - 60);
         $(this).parent().width($(this).width() + 30);
       });
    }
    recalc_balance_div_width();


    //Buttons

//    <input name="utf8" type="hidden" value="&#x2713;" />
//    <input name="authenticity_token" type="hidden" value="p2g3unhj8eicE3/UtJsZAOrolHM9LZN0/cavwJsushs=" />

    $("#UpdateCampaignButton").click(function(){
        $(this).parents("form:first").submit();
        return false;
    });

    function display_error(msg){
      $("#error_message_static").hide();
      $("#notice_message_static").hide();
      $("#notice_message").hide();
      $("#error_message div p").html(msg);
      $("#error_message").show();
    }

    function display_notice(msg){
      $("#error_message_static").hide();
      $("#notice_message_static").hide();
      $("#error_message").hide();
      $("#notice_message div p").html(msg);
      $("#notice_message").show();
    }


    var decrease_budget_html = '<div id="BudgetBox">' +
            '<p class="Header">Уменьшить баланс кампании на:</p>'+
            '<p class="Attention">(Ваш текущий общий баланс '+$("#member_balance").html()+' руб.)</p>'+
            '<p class="Roubles">Введите сумму:<input class="BigInput" id="decrease_sum" />руб.</p>' +
            '<p class="Button"><a class="GreenButton" href="#" id="DecreaseBudgetButton"><span>Уменьшить</span></a></p>'+
            '<p class="AttentionDown">Сумма, на которую вы уменьшите бюджет, вернется вам в виртуальный кошелек, ' +
            'такими образом вы можете перераспределять средства между кампаниями.</p>'+
            '</div>';

    $("#budget_decrease").click(function(){
        $.colorbox({html:decrease_budget_html});
        $("#DecreaseBudgetButton").click(function(){
            var campaign_id = $("#campaign_id").html();
            var decrease_sum = $("#decrease_sum").val();
            $.ajax({
                      url: "/ajax/campaign_decrease_budget",
                      type: "POST",
                      data: {id : campaign_id, sum : decrease_sum},
                      success: function(msg){
                        if (msg == "0")
                        {
                           var s = parseInt(decrease_sum);
                           $("#member_balance").html(parseInt($("#member_balance").html()) + s);
                           $("#campaign_balance").html(parseInt($("#campaign_balance").html()) - s);

                           //integer.parse(decrease_sum);
                           display_notice("Баланс кампании уменьшен.");
                           recalc_balance_div_width();
                        }
                        else if (msg == "1")
                        {
                           display_error("Не хватает средств на счете кампании.");
                        }
                        else
                        {
                           display_error("Введите число.");
                        }
                      }
                   });
            $.colorbox.close();
            return false;
        });
        return false;
    });


    var increase_budget_html = '<div id="BudgetBox">' +
            '<p class="Header">Увеличить баланс кампании на:</p>'+
            '<p class="Attention">(Ваш текущий общий баланс '+$("#member_balance").html()+' руб.)</p>'+
            '<p class="Roubles">Введите сумму:<input class="BigInput" id="increase_sum" />руб.</p>' +
            '<p class="Button"><a class="GreenButton" href="#" id="IncreaseBudgetButton"><span>Увеличить</span></a></p>'+
            '<p class="AttentionDown">Сумма, на которую вы увеличите бюджет, будет списана с вашего виртуального кошелька.</p>'+
            '</div>';

    $("#budget_increase").click(function(){
        $.colorbox({html:increase_budget_html});
        $("#IncreaseBudgetButton").click(function(){
            var campaign_id = $("#campaign_id").html();
            var increase_sum = $("#increase_sum").val();
            $.ajax({
                      url: "/ajax/campaign_increase_budget",
                      type: "POST",
                      data: {id : campaign_id, sum : increase_sum},
                      success: function(msg){
                        if (msg == "0")
                        {
                           var s = parseInt(increase_sum);
                           $("#member_balance").html(parseInt($("#member_balance").html()) - s);
                           $("#campaign_balance").html(parseInt($("#campaign_balance").html()) + s);

                           //integer.parse(decrease_sum);
                           display_notice("Баланс кампании увеличен.");
                           recalc_balance_div_width();
                        }
                        else if (msg == "1")
                        {
                           display_error("Не хватает средств на личном счете.");
                        }
                        else
                        {
                           display_error("Введите число.");
                        }
                      }
                   });
            $.colorbox.close();
            return false;
        });
        return false;
    });



    //Ad ajax + controlling

    function add_height_to_ad_container(delta){
        $("div.Container div.AdInfo").height(
                     $("div.Container div.AdInfo").height() + delta
                );
        $("div.Container div.AdInfo div.LeftColumn").height(
                     $("div.Container div.AdInfo div.LeftColumn").height() + delta
                );
        $("div.Container div.AdInfo div.LeftColumn div").height(
                     $("div.Container div.AdInfo div.LeftColumn div").height() + delta
                );
    }


    Array.prototype.contains = function ( needle ) {
      for (var i in this) {
        if (this[i] == needle) return true;
      }
      return false;
    };
    Array.prototype.remove = function ( needle ) {
      for(var i=0; i< this.length;i++ )
      {
        if(this[i]==needle)
            return this.splice(i,1);
      }
      return this;
    };


    var city_element_height = $("#any_city").height()+10;
    var platform_element_height = $("#all_platforms").height()+10;


    //Cities targeting

    var dispatchCityDelete = function(){
        var city_id = $(this).parent().children("span").html();
        var cities = $("#ad_cities").val().split(",");
        cities.remove(city_id);
        $("#ad_cities").val(cities.join(","));
        $(this).parent().remove();
        if (cities.length == 0)
        {
           $("#any_city").show();
        }
        else
        {
            add_height_to_ad_container(-city_element_height);
        }
        return false;
    };

    function add_city(id, name){
       $("#any_city").hide();
       var cities = [];
       if ($("#ad_cities").val() != "")
       {
         cities = $("#ad_cities").val().split(",");
       }

       if (!cities.contains(id.toString()))
       {
           if (cities.length > 0)
             $("#ad_cities").val($("#ad_cities").val() + "," + id.toString());
           else
             $("#ad_cities").val(id.toString());
           $("#cities_container").prepend('<p><span style="display:none;">'+id.toString()+'</span>'+name.toString()+
                   ' <a href="#">(удалить)</a></p>');
           $("#cities_container p:first a").click(dispatchCityDelete);
           if (cities.length > 0)
             add_height_to_ad_container(city_element_height);
       }
    }

    if ($("#ad_cities").val() != "")
        $("#any_city").hide();
    $("#cities_container").prepend($("#cities_prepared").html());
    $("#cities_container p a").click(dispatchCityDelete);

    $("#country_select").change(function(){
        var country_id = $("#country_select").val();
        $("#city_select").html("");
        if (country_id != "")
        {
            $.ajax({
                url: "/ajax/cities_for_country",
                type: "POST",
                data: {"country_id" : country_id},
                success: function(msg){
                    $("#city_select").html(msg);
                    //alert(msg);
                }
            });
        }
    });

    $("#add_city_link").click(function(){
        var city_id = $("#city_select").val();
        var city_name = $("#city_select :selected").text();
        if (city_name != "")
        {
            add_city(city_id, city_name);
        }
        return false;
    });

    //Platform targeting

    var dispatchPlatformDelete = function(){
        var platform_id = $(this).parent().children("span").html();
        var platforms = $("#ad_platforms").val().split(",");
        platforms.remove(platform_id);
        $("#ad_platforms").val(platforms.join(","));
        $(this).parent().remove();
        if (platforms.length == 0)
        {
           $("#all_platforms").show();
        }
        else
        {
            add_height_to_ad_container(-platform_element_height);
        }
        return false;
    };

    function add_platform(id, name){
       $("#all_platforms").hide();
       var platforms = [];
       if ($("#ad_platforms").val() != "")
       {
         platforms = $("#ad_platforms").val().split(",");
       }

       if (!platforms.contains(id.toString()))
       {
           if (platforms.length > 0)
             $("#ad_platforms").val($("#ad_platforms").val() + "," + id.toString());
           else
             $("#ad_platforms").val(id.toString());
           $("#platforms_container").prepend('<p><span style="display:none;">'+id.toString()+'</span>'+name.toString()+
                   ' <a href="#">(удалить)</a></p>');
           $("#platforms_container p:first a").click(dispatchPlatformDelete);
           if (platforms.length > 0)
             add_height_to_ad_container(platform_element_height);
       }
    }

    if ($("#ad_platforms").val() != "")
        $("#all_platforms").hide();
    $("#platforms_container").prepend($("#platforms_prepared").html());
    $("#platforms_container p a").click(dispatchCityDelete);

    $("#add_platform_link").click(function(){
        var platform_id = $("#platform_select").val();
        var platform_name = $("#platform_select :selected").text();
        if (platform_name != "")
        {
            add_platform(platform_id, platform_name);
        }
        return false;
    });


    if ($("#edit_ad").height() > 0)
    {
        $("div.Container div.AdInfo").not(".field_with_errors").height($("#edit_ad").height() + 40);
        $("div.Container div.AdInfo div.LeftColumn").not(".field_with_errors").height($("#edit_ad").height() + 40);
        $("div.Container div.AdInfo div.LeftColumn div").not(".field_with_errors").height($("#edit_ad").height());
    }
    else
    {
        $("div.Container div.AdInfo").not(".field_with_errors").height($("#create_ad").height() + 40);
        $("div.Container div.AdInfo div.LeftColumn").not(".field_with_errors").height($("#create_ad").height() + 40);
        $("div.Container div.AdInfo div.LeftColumn div").not(".field_with_errors").height($("#create_ad").height());
    }

    //Different ad type support

    function set_ad_type_banner()
    {
        $(".ImageUpload").removeClass("TextGraph");
        $(".ImageUpload").addClass("Banner");
    }

    function set_ad_type_textgraph()
    {
        $(".ImageUpload").removeClass("Banner");
        $(".ImageUpload").addClass("TextGraph");
    }

    $("#ad_ad_type_0").change(function(){
       alert("Banner!")
       set_ad_type_banner();
    });

    $("#ad_ad_type_1").change(function(){
       alert("TextGraph!")
       set_ad_type_textgraph();
    });


    //Image uploading

    $("div.Container div.ImageUpload div:nth-child(2)").each(function(){
        $(this).width($("#upload_image_field").width() + 30);
    });

    $("#upload_image_field").click(function(){
        //$("#upload_image").click();
        return false;
    });

    $("#upload_image").change(function(){
        $("#upload_image_field").val($("#upload_image").val());
    });


    $("#image_upload_form").ajaxForm({
       dataType:"json",
       success:function(msg){
          if (msg == "1"){
            display_error("Изображение имеет неверный формат");
          } else {
            $("#ad_image_url").val(msg);
            //alert($("#ad_image_url").val());
            $("#image_tag").attr("src", msg);
            $("#upload_image_field").val("");
            $("#upload_image").val("");
            display_notice("Изображение изменено");
          }
       }
    });

    $("#UploadImage").click(function(){
        $("#image_upload_form").submit();
        return true;
    });

    //Buttons dispatching

    $("#UpdateAdButton").click(function(){
        $("#edit_ad").submit();
        return false;
    });

    $("#CreateAdButton").click(function(){
        $("#create_ad").submit();
        return false;
    });




});
