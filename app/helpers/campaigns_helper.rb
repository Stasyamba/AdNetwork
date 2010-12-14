module CampaignsHelper

  def select_campaign_status f, status
    if (status == Campaign::STATUS_TMP_STOPPED)
      f.select :status,
               [["Приостановлена", Campaign::STATUS_TMP_STOPPED]],
               {},
               {:class => "BigInput", :disabled => true}
    else
      f.select :status,
               [["Запущена", Campaign::STATUS_STARTED], ["Остановлена", Campaign::STATUS_STOPPED]],
               {},
               {:class => "BigInput", :length => 30}
    end
  end

  def campaign_status status
    if (status == Campaign::STATUS_STARTED)
      return "Запущена"
    else
      if status == Campaign::STATUS_STOPPED
        return "Остановлена"
      end
    end
    "Приостановлена"  
  end

end
