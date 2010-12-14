module AdsHelper


  def select_sex f, sex
    f.select sex,
             [["Не важно", Ad::SEX_BOTH],
              ["Мужской", Ad::SEX_MALE],
              ["Женский", Ad::SEX_FEMALE]],
             {},
             {:class => "BigInput", :length => 15}
  end

  def select_age f, age, special_age
    diapason = (10..70).to_a
    if (special_age == Ad::AGE_MIN)
      diapason = diapason.map { |e| 80 - e }
    end
    options = (diapason + [special_age]).map do |e|
      if (e == special_age)
        ["Не важно", e]
      else
        [e, e]
      end
    end
    f.select age, options, {}, {:class => "BigInput", :length => 15}
  end


  def select_ad_status f, status
    if (status == Ad::STATUS_AWAITING || status == Ad::STATUS_AWAITING_STOPPED)
      f.select :status,
               [[ad_status(Ad::STATUS_AWAITING), Ad::STATUS_AWAITING],
                [ad_status(Ad::STATUS_AWAITING_STOPPED), Ad::STATUS_AWAITING_STOPPED]],
               {},
               {:class => "BigInput", :disabled => true}
    else
      f.select :status,
               [[ad_status(Ad::STATUS_RUNNING), Ad::STATUS_RUNNING],
                [ad_status(Ad::STATUS_STOPPED), Ad::STATUS_STOPPED]],
               {},
               {:class => "BigInput", :length => 30}
    end
  end


end
