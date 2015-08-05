class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  @@URI = "http://www.openligadb.de"
  @@API_PATH = "/api/getmatchdata"
  @@API_CURR = "/api/getcurrentgroup"
  @@LEAGUE = "bl1"
  @@SAISON = "2015"
  
  helper_method :current_user
  
  
  def current_user
    current_user=User.find(session[:user_id]) if session[:user_id]
    current_user.role=session[:hgcAdmin]  if session[:user_id]
	  @current_user ||= current_user
  end
  
  def require_user
	  redirect_to '/login' unless current_user
  end
  
  def require_admin
	  redirect_to '/home' unless current_user && (current_user.admin? || session[:hgcAdmin])
  end
end
