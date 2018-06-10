require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "注册成功的测试" do
    get signup_path
    assert_difference 'User.count',1 do
      post users_path,params: {
          user: { name: "Example User",
                  email: "user@example.com",
                  password: "password",
                  password_confirmation: "password" }
      }
    end
    follow_redirect!
    assert_template 'users/show'
  end
  test "注册失败的测试" do
    get signup_path
    #routes.rb中添加了：  get '/signup',to: 'users#new'
    # 因此signup_path和signup_url可用
    assert_no_difference 'User.count' do
      post users_path, params: {
          user:
              { name: "",
                email: "user@invalid",
                password: "foo",
                password_confirmation: "bar"
              }
      }
    end
    #assert_no_difference 'User.count' do ....end
    # 其实相当于这样：
=begin
    before_count = User.count
    post users_path, ...
    after_count = User.count
    assert_equal before_count, after_count
=end
  end



#闪现消息测试
  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password:
                                             "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
  end
#注册后直接登录的测试
  test "注册后直接登录的测试" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                         email: "user@example.com",
                                         password:
                                             "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end
end
