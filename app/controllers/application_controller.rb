class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include SessionsHelper
  before_action :current_user
  before_filter :authorize
  before_filter :teacher
  
  protected

    def admin
      unless @current_user && 0==@current_user.admin
        flash[:msg] = '权限严重不足'
        redirect_to :back
      end
    end

    def teacher
      unless @current_user && (0==@current_user.admin or 1==@current_user.admin)
        flash[:msg] = '权限不足'
        redirect_to :back
      end
    end

    def authorize
      unless User.find_by_id(session[:user_id])
        flash[:msg] = '请登录'
        redirect_to :root
      end
    end

end
