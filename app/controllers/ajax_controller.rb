require "RMagick"
class AjaxController < ApplicationController
  before_filter :check_login, :except => [:cities_for_country]

  def campaign_increase_budget
    id, sum = params[:id].to_i, params[:sum].to_i
    if (id == 0 or sum == 0)
      render :text => "2"
    else
      campaign = Campaign.find(id)
      member = Member.find(session[:member_id])
      if (campaign.member_id != member.id)
        render :text => "Иди на хуй сучий потрох!"
      else
        if member.balance < sum
          render :text => "1"
        else
          campaign.balance += sum
          member.balance -= sum
          ActiveRecord::Base.transaction do
            campaign.save!
            member.save!
          end
          session[:member_balance] = member.balance
          render :text => "0"
        end
      end
    end
  end

  def campaign_decrease_budget
    id, sum = params[:id].to_i, params[:sum].to_i
    if (id == 0 or sum == 0)
      render :text => "2"
    else
      campaign = Campaign.find(id)
      member = Member.find(session[:member_id])
      if (campaign.member_id != member.id)
        render :text => "Иди на хуй сучий потрох!"
      else
        if campaign.balance < sum
          render :text => "1"
        else
          campaign.balance -= sum
          member.balance += sum
          ActiveRecord::Base.transaction do
            campaign.save!
            member.save!
          end
          session[:member_balance] = member.balance
          render :text => "0"
        end
      end
    end
  end

  def cities_for_country
    render :text => City.where(["country_id = ?", params[:country_id]]).map { |c| "<option value=\"#{c.id}\">#{c.name}</option>\n" }
  end

  def upload_image
    begin
      file = params[:image]
      image = Magick::Image.read(file.path).first
      thumb = image.resize_to_fit(740, 80)
      name = (0..16).to_a.map{|a| rand(16).to_s(16)}.join + ".jpg"
      thumb.write("public/images/banners/" + name)
      render :text => "\"http://#{request.env["HTTP_HOST"]}/images/banners/#{name}\"";
    rescue
      render :text => "1"
    end
  end

end
