require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @user = users(:michael)
    @other_user=users(:arche)
  end
  #测试ｅｄｉｔ方法是受保护的，即没有登录不能发访问
  # （）
  test "模拟用户没有登录直接访问edit" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "模拟用户没有登录直接访问update" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test "访问修改其他人的页面，should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  test "修改其他人的信息should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end



  test "should redirect index when not logged in" do
    #debugger
    #users_path ----  "/users"
    #
    get users_path
    assert_redirected_to login_url
  end
end
