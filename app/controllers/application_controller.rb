# class ApplicationController
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  private

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  helper_method :current_user

  def user_preference
    @preference ||= current_user.preference if session[:user_id]
  end
  helper_method :user_preference

  def authorize
    redirect_to login_path unless current_user
  end
end
