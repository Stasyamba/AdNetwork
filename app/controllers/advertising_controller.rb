require "digest/sha2"
class AdvertisingController < ApplicationController

  LINK_VALID_PERIOD = 3600
  CLICK_AGAIN_PERIOD = 60

  def get_ads
    type = params[:type].to_i
    platform_id = params[:platform_id].to_i
    age = params[:age].to_i
    sex = params[:sex].to_i
    city_id = params[:city_id].to_i

    type_clause = "ad_type = ?"
    sex_clause = "sex = #{Ad::SEX_BOTH} OR sex = ?"
    age_clause = "min_age <= ? and max_age >= ?"
    platform_clause = "platform_id = #{Ad::ANY_PLATFORM} OR platform_id = ?"
    city_clause = "city_id = #{Ad::ANY_CITY} OR city_id = ?"

    avg_ctr = 0.0015

    ads = AdDynamic.where([type_clause, type]).where([sex_clause, sex]).where([age_clause, age, age])
    ads = ads.where([platform_clause, platform_id]).where([city_clause, city_id]).to_a
    ads.each do |ad|
      ctr = (ad.ctr if ad.clicks > 1000) || avg_ctr
      ad.rand = 1.0 / (ctr * ad.click_cost * rand(1000000000))
    end
    ads.sort! { |a,b| a.rand <=> b.rand }

    if not ads.empty?
      ads.first.link = make_link ads.first
      render :json => ads.first.to_json
    else
      render :text => "{}"
    end
  end

  def click
    campaign_id = params[:campaign_id].to_i
    ad_id = params[:ad_id].to_i
    url = params[:url]
    click_cost = params[:click_cost].to_f
    ts = params[:ts].to_i
    rand = params[:rand].to_i
    sig = params[:sig]

    now_ts = Time.now.to_i

    if sig != get_signature([ad_id, campaign_id, url, click_cost, ts, rand])
      render :text => "Bad signature"
    elsif now_ts - ts > LINK_VALID_PERIOD
      render :text => "Link is too old"
    else
      if session["clicked_ad_#{ad_id}"] && session["clicked_ad_#{ad_id}"].to_i + CLICK_AGAIN_PERIOD > now_ts
        render :text => "Redirecting to #{url}, but already clicked on it"
      else
        session["clicked_ad_#{ad_id}"] = now_ts
        stat_ad_click ad_id, campaign_id, click_cost
        render :text => "Redirecting to #{url}"
      end
    end
  end

  def get_ads_details

    type = params[:type].to_i
    platform_id = params[:platform_id].to_i
    age = params[:age].to_i
    sex = params[:sex].to_i
    city_id = params[:city_id].to_i

    type_clause = "ad_type = ?"
    sex_clause = "sex = #{Ad::SEX_BOTH} OR sex = ?"
    age_clause = "min_age <= ? and max_age >= ?"
    platform_clause = "platform_id = #{Ad::ANY_PLATFORM} OR platform_id = ?"
    city_clause = "city_id = #{Ad::ANY_CITY} OR city_id = ?"

    avg_ctr = 0.0015

    ads = AdDynamic.where([type_clause, type]).where([sex_clause, sex]).where([age_clause, age, age])
    ads = ads.where([platform_clause, platform_id]).where([city_clause, city_id]).to_a


    if ads.count > 0
      ads.each do |ad|
        ad.link = make_link ad
        ad.vs = 0
      end
      10000.times do
        ads.each do |ad|
          ctr = (ad.ctr if ad.clicks > 1000) || avg_ctr
          ad.rand = 1.0 / (ctr * ad.click_cost * rand(1000000000))
        end
        ads.sort!{ |a,b| a.rand <=> b.rand }
        ads.first.vs += 1
      end
      ads.each do |ad|
        ad.chance = ad.vs / 10000.0;
      end
    end

    ads.each do |ad|
      ctr = (ad.ctr if ad.clicks > 1000) || avg_ctr
      ad.rand = 1.0 / (ctr * ad.click_cost * rand(1000000000))
    end
    ads.sort! { |a,b| a.rand <=> b.rand }

    if not ads.empty?
      ads.first.rand = 0.0
      stat_ad_view ads.first.ad_id
    end

    @ads = ads

  end

  def test_app

    #render :text => ActiveRecord::Base.connection.type
  end

  private

  def make_link ad
    ts = Time.now.to_i
    rn = rand(10000)
    sig = get_signature [ad.ad_id, ad.campaign_id, ad.click_cost, ad.link, ts, rn ]

    url_for :controller => "advertising", :action => "click",
            :ad_id => ad.ad_id, :campaign_id => ad.campaign_id,
            :click_cost => ad.click_cost,
            :url => ad.link, :ts => ts, :rand => rn,  :sig => sig

  end

  def get_signature params
    p = params.map{|p|p.to_s}.sort.join
    Digest::SHA2.hexdigest "Take #{p} and something and make hash, mortal!"
  end

  def stat_ad_view ad_id
    Ad.update_all("views = views + 1", ["id = ?", ad_id])
  end

  def stat_ad_click ad_id, campaign_id, click_cost
    Ad.update_all(["clicks = clicks + 1, expenses = expenses + ?", click_cost], ["id = ?", ad_id])
    Campaign.update_all(["balance = balance - ?", click_cost], ["id = ?", campaign_id])
  end


end
