class SessionsController < ApplicationController
  skip_before_filter :authorize
  skip_before_filter :teacher

  def news
  end  

  def create  
    sleep(0.5)
    respond_to do |format|
      if user = User.authenticate(params[:session][:name], params[:session][:password])
        remember_token = user.id.to_s+SecureRandom.urlsafe_base64
        session[:user_id] = user.id
        if params[:session][:remember_me]=="1"
          cookies.permanent[:remember_token] = remember_token 
          @session = Session.new
          @session.user_id = user.id
          @session.remember_token = remember_token
          if @session.save
          else
            flash[:error] = '登录出错'
          end
        end
        format.js
      else
        flash[:error] = '登录信息不正确'
        format.js
      end
    end
    
  end  

  def destroy  
    session[:user_id] = nil
    @session = Session.find_by_remember_token(cookies.permanent[:remember_token])
    @session && @session.destroy
    cookies.delete(:remember_token)
    redirect_to :root
  end  
"""
  def new
    if User.find_by_id(session[:user_id])
      redirect_to user_index_path, :notice => ''
    end
  end

  def create
    sleep(1)  
    if user = User.authenticate(params[:name], params[:password])
      session[:user_id] = user.id
      if user.admin?
        format.js   
      else
        format.js   
      end
    else
      format.js   
    end
  end

  def destroy
    session[:user_id] = nil
  end
  """
  
end
