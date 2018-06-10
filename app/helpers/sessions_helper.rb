module SessionsHelper
  # 登入指定的用户
  def log_in(user)
    session[:user_id] = user.id
  end
  def current_user
    User.find_by(id: session[:user_id])
    # @current_user = @current_user || User.find_by(id: session[:user_id])
    if @current_user.nil?
      @current_user = User.find_by(id: session[:user_id])
    else
      @current_user
    end
  end

  # 如果用户已登录,返回 true ,否则返回 false
  def logged_in?
    !current_user.nil?
  end

  # 退出当前用户
  def log_out
    session.delete(:user_id)
    @current_user = nil
  end
end
