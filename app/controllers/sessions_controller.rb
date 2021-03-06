class SessionsController < ApplicationController

  def new
    #debugger
  end
  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
# 登入用户,然后重定向到用户的资料页面
      log_in @user
      #记住用户
      params[:session][:remember_me]=='1' ? remember(@user) : forget(@user)
      #redirect_to @user
      # 相当于redirect_to user_url(user)
      # user_url(user)  "http://0.0.0.0:3000/users/5"
      redirect_back_or @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end
  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
