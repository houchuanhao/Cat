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
      #raise  # 测试仍能通过,所以没有覆盖这个分支
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

  # 如果指定用户是当前用户,返回 true
  def current_user?(user)
    user == current_user
  end




  #修改用户信息时如果没有登录，此时就会跳转到登录页面
  # 当登录之后，会再跳回到修改信息页面
  # 重定向到存储的地址或者默认地址
  def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
    session.delete(:forwarding_url)
  end
  # 存储后面需要使用的地址
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
