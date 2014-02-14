module SessionsHelper
  def current_user
  	@token ||= Session.find_by_remember_token(cookies.permanent[:remember_token])
    @token && (session[:user_id] = @token.user_id)
    @current_user ||= User.find_by_id(session[:user_id])
  end  
end
