class UsersController < ApplicationController
  def new
    @user=User.new
    flash[:info]="info测试"
  end
  def create
    #debugger
    @user=User.new(user_params)
    if @user.save
      #debugger
      log_in @user
      flash[:success]="Welcome to the Sample App!"
      remember @user
      redirect_to @user
      #redirect_to是重定向的意思
      #redirect_to @user等价于 redirect_to user_url(@user)
      # user_url(@user)返回结果为 "http://0.0.0.0:3000/users/7"
      # user_path(@user)返回结果为 "/users/7"
    else
      #debugger
      # @user.errors.empty?
      # @user.errors.any?与empty相反
      # @user.errors.count
      #当@user不合法时，可以调用@user.errors.full_messages获取错误信息，其返回结果为一个数组
      render 'new'
    end
  end
  def show
    @user=User.find(params[:id])
    # debugger #Ctrl+D键退出
  end


  private def user_params
    #permit许可证
    # 其实相当于params[:user],只不过rails中为了安全，防止传过来其他参数，于是添加了许可证，只要permit里的这几个键对应的值
    return params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end
end
