class UsersController < ApplicationController
  #new -->create
  # edmit--->update
  # index(所有)　show(单个)
  # delete
  # 在执行edit,uodate之前，都要确保用户已登录，
  # 如果没有登录，跳转到登录界面
  before_action :logged_in_user,only: [:edit,:update,:index]
  before_action :correct_user,only: [:edit,:update]
  def new
    #debugger
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

  def index

    #User.paginate用于分页
    #参数为哈希，page:　表示显示第几页，如果为nil则显示第一页
    @users=User.paginate(page: params[:page])
    #问题：
    # 分页对象属于哪个 Ruby 类?与 User.all 有什么不同?
  end
  def show
    @user=User.find(params[:id])
    # debugger #Ctrl+D键退出
  end
  #接收get请求
  def edit
    @user=User.find_by(id: params[:id])
  end
  #update接收patch请求
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success]="修改成功"
      redirect_to @user
# 处理更新成功的情况
    else
      flash[:warning]="编辑失败！"
      render 'edit'
    end
  end
  private def user_params
    #permit许可证
    # 其实相当于params[:user],只不过rails中为了安全，防止传过来其他参数，于是添加了许可证，只要permit里的这几个键对应的值
    return params.require(:user).permit(:name,:email,:password,:password_confirmation)
  end


  # 确保用户已登录
  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "请登录！"
      redirect_to login_url
    end


    # 确保是正确的用户
    def correct_user
      #@user是根据请求中的id字段得到的用户
      # current_user是ｓｅｓｓｉｏｎ中的用户
      @user = User.find(params[:id])
      #redirect_to(root_url) unless @user == current_user
      # 定义了current_user?(user)方法后:
      if(!current_user?(@user))
        #flash[:warning]="不可修改别人的信息"
        # users_controller_test.rb中
        # "修改其他人的信息should redirect update when logged in as wrong user"测试中
        # 有断言，assert flash.empty?
        redirect_to root_url
      end
    end
  end
end
