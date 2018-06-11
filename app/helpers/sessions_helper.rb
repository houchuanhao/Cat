module SessionsHelper
  # 登入指定的用户
  def log_in(user)
    session[:user_id] = user.id
    end
=begin
  def current_user
    User.find_by(id: session[:user_id])
    # @current_user = @current_user || User.find_by(id: session[:user_id])
    if @current_user.nil?
      @current_user = User.find_by(id: session[:user_id])
    else
      @current_user
    end
  end
=end

  # 返回 cookie 中记忆令牌对应的用户
  def current_user
    if (user_id = session[:user_id]) #临时会话session中有user_id
      @current_user ||= User.find_by(id: user_id)
      #临时会话session中没有user_id，从持久会话cookie中取
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end
  # 如果用户已登录,返回 true ,否则返回 false
  def logged_in?
    !current_user.nil?
  end
  #忘记用户
  def forget(user)
 #   if(!user.nil?)
    user.forget
  #  end
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end
  # 退出当前用户
  def log_out
    session.delete(:user_id)
    forget(@current_user)
    @current_user = nil
  end

  # 在持久会话中记住用户
  def remember(user)
    user.remember
    #pｅｒmanent表示cookie过期时间为20年
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end
end
