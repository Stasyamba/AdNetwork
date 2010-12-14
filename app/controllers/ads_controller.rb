class AdsController < ApplicationController

  layout "advertiser_webmaster"
  
  before_filter :check_login
  before_filter :init_advertiser
  before_filter :check_access
  
  def index
    @campaign = @campaign || Campaign.find(params[:campaign_id])
    @campaign_name = @campaign_name || @campaign.name
    if (@campaign.member_id != session[:member_id])
      redirect_to campaigns_url
    end
    
    @campaign.calculate_statistics
    render :action => "campaigns/show"
  end

  def show
    
    @campaign = @campaign || Campaign.find(params[:campaign_id])
    if (@campaign.member_id != session[:member_id])
      redirect_to campaigns_url
    end

    @ad = Ad.find(params[:id])
    @ad_name = @ad.name
    if (@ad.campaign_id != @campaign.id)
      redirect_to campaigns_url
    end

    @ad_cities = @ad.cities
    @ad_platforms = @ad.platforms
    
  end

  def new

    @campaign = @campaign || Campaign.find(params[:campaign_id])
    if (@campaign.member_id != session[:member_id])
      redirect_to campaigns_url
    end

    @ad = Ad.new(:campaign_id => @campaign.id)
    @ad_name = "Новое объявление"
    @ad_cities = @ad.cities
    @ad_platforms = @ad.platforms

    
  end

  def create
    @campaign = @campaign || Campaign.find(params[:campaign_id])
    if (@campaign.member_id != session[:member_id])
      redirect_to campaigns_url
    end

    @ad = Ad.new(params[:ad])
    @ad_name = "Новое объявление"
    @ad.campaign_id = @campaign.id

    @ad_cities = @ad.cities = City.where(["id IN (?)", params[:ad][:cities].split(",")])
    @ad_platforms = @ad.platforms = Platform.where(["id IN (?)", params[:ad][:platforms].split(",")])

    if @ad.save
      flash.now[:notice_msg] = "Объявление создано"
      index
    else
      flash.now[:error_msg] = "Объявление не создано"
      render "new"
    end
  end

  def update

    @campaign = @campaign || Campaign.find(params[:campaign_id])
    if (@campaign.member_id != session[:member_id])
      redirect_to campaigns_url
    end

    @ad = Ad.find(params[:id])
    @ad_name = @ad.name
    if (@ad.campaign_id != @campaign.id)
      redirect_to campaigns_url
    end

    @ad_cities = @ad.cities = City.where(["id IN (?)", params[:ad][:cities].split(",")])
    @ad_platforms = @ad.platforms = Platform.where(["id IN (?)", params[:ad][:platforms].split(",")])

    if (@ad.update_attributes(params[:ad]))
      @ad.status = params[:ad][:status]
      @ad.save!
      flash.now[:notice_msg] = "Объявление сохранено"
    else
      flash.now[:error_msg] = "Объявление не было сохранено"
    end

    render "show"
  end

  private

  def init_advertiser
    @balance = session[:member_balance]
    @webmaster = false
  end

  def check_access

  end

end
