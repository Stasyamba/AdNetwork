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

    ActiveRecord::Base.transaction do
      @ad_cities = @ad.cities = City.where(["id IN (?)", params[:ad][:cities].split(",")])
      @ad_platforms = @ad.platforms = Platform.where(["id IN (?)", params[:ad][:platforms].split(",")])

      @ad.status = Ad::STATUS_AWAITING_STOPPED

      if @ad.save
        flash.now[:notice_msg] = "Объявление создано и отправлено на проверку"
        index
      else
        flash.now[:error_msg] = "Объявление не создано"
        render "new"
        raise ActiveRecord::Rollback
      end
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
    @ad_name = @ad.name
    ActiveRecord::Base.transaction do
      @ad_cities = @ad.cities = City.where(["id IN (?)", params[:ad][:cities].split(",")])
      @ad_platforms = @ad.platforms = Platform.where(["id IN (?)", params[:ad][:platforms].split(",")])

      bad = false
      need_check = false

      if (@ad.name != params[:ad][:name] or
          @ad.ad_type.to_s != params[:ad][:ad_type] or
          @ad.description != params[:ad][:description] or
          @ad.link != params[:ad][:link] or
          @ad.image_url != params[:ad][:image_url]
      )
        need_check = true
      end

      @ad.attributes = params[:ad]
      if @ad.status == Ad::STATUS_RUNNING or @ad.status == Ad::STATUS_STOPPED
        @ad.status = params[:ad][:status]
      end
      if need_check
        @ad.status = Ad::STATUS_AWAITING_STOPPED
        @ad.status = Ad::STATUS_AWAITING if params[:ad][:status] == Ad::STATUS_RUNNING
      end

      bad = true and @ad.status = params[:ad][:status] if not @ad.save

      flash.now[:notice_msg] = "Объявление сохранено"
      flash.now[:notice_msg] = "Объявление сохранено и отправлено на проверку" if need_check
      ((flash.now[:error_msg] = "Объявление не было сохранено") and
       (flash.now[:notice_msg] = nil) and
       raise(ActiveRecord::Rollback)) if bad
    end

    @ad_name = @ad.name unless @ad.name.empty?
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
