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
