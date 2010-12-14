class ApplicationController < ActionController::Base
  protect_from_forgery

#  rescue_from 

  def index
    if session[:user_id]
      redirect_to :controller => "members"
    else
      redirect_to "/login"
    end
  end

  def login
    
  end

  def try_login
    member = Member.authenticate params[:login], params[:password]
    if member
      session[:member_id] = member.id
      session[:member_balance] = member.balance
      redirect_to campaigns_path
    else
      flash[:error] = "Пошёл!"
      redirect_to "/login"
    end
  end

  def logout
    session[:member_id] = nil
    session[:member_balance] = nil
    redirect_to "/login"
  end

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

    #render :json => ads.first.to_json
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


    @ads = ads

  end

  def click


    render :text => "Clicked"
  end

  def test_app


    #render :text => ActiveRecord::Base.connection.type
  end

  private

  def check_login
    if (session[:member_id])
      true
    else
      redirect_to "/login"
      false
    end
  end

end
