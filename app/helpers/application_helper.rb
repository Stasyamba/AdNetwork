module ApplicationHelper

  def advertiser_img_tag link
    "<a href=\"#{link}\"><img src=\"/images/AdvButtonNormal.png\" /></a>".html_safe
  end

  def advertiser_img_tag_clicked
    "<img src=\"/images/AdvButtonSelected.png\" />".html_safe
  end

  def webmaster_img_tag link
    "<a href=\"#{link}\"><img src=\"/images/WebmastersButtonNormal.png\" /></a>".html_safe
  end

  def webmaster_img_tag_clicked
    "<img src=\"/images/WebmastersButtonSelected.png\" />".html_safe
  end

  def ad_status status
    case status
      when Ad::STATUS_AWAITING, Ad::STATUS_AWAITING_STOPPED
        "На модерации"
      when Ad::STATUS_RUNNING
        "Запущено"
      when Ad::STATUS_STOPPED
        "Остановлено"
    end
  end

  def ad_type type
    case type
      when Ad::TYPE_BANNER
        "Баннер"
      when Ad::TYPE_TEXT_GRAPH
        "Текстово-графический"
    end
  end

  def ctr_percent ctr
    format("%.4f%", ctr * 100.0)
  end


end
