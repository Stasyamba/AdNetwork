class CampaignsController < ApplicationController

  layout "advertiser_webmaster"
  before_filter :check_login
  before_filter :init_advertiser

  def index
    @campaigns = Campaign.where(["member_id = ?", session[:member_id]]).order("created_at DESC")
    @campaigns.each do |c|
      c.calculate_statistics
    end
  end

  def new
    @campaign = Campaign.new
  end

  def create
    @campaign = Campaign.new params[:campaign]
    @campaign.member_id = session[:member_id]
    if @campaign.save
      flash.now[:notice_msg] = "Кампания создана. Добавьте в нее объявления."
      index
      render "index"
    else
      flash.now[:error_msg] = "Укажите название кампании."
      render "new"
    end
  end

  def show
    @campaign = @campaign || Campaign.find(params[:id])
    @campaign_name = @campaign_name || @campaign.name
    if (@campaign.member_id != session[:member_id])
      redirect_to campaigns_url
    end
    @campaign.calculate_statistics
  end

  def update
    @campaign = Campaign.find(params[:id])
    @campaign_name = @campaign.name
    if (@campaign.member_id != session[:member_id])
      redirect_to campaigns_url
    end
    if @campaign.update_attributes params[:campaign]
      flash.now[:notice_msg] = "Изменения сохранены."
      @campaign_name = @campaign.name
      show
      render "show"
    else
      flash.now[:error_msg] = "Изменения не сохранены."
      show
      render "show"      
    end
  end

  private

  def init_advertiser
    @balance = session[:member_balance]
    @webmaster = false
  end

end
