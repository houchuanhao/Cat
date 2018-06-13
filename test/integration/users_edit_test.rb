require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  #template :模板
  def setup
    @user = users(:michael)
  end
  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
        user: { name: "",
                email: "foo@invalid",
                password: "foo",
                password_confirmation: "bar"
        }
    }
    assert_template 'users/edit'
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {
        user: { name: name,
                email: email,
                password: "",
                password_confirmation: ""
        }
    }
    assert_not flash.empty?
    assert_redirected_to @user  #更新时允许密码为空
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
  #如果未登录的用户访问了编辑资料页面,
  # 网站要求先登录,登录后会重定向到
  #/users/1,而不是 /users/1/edit。
  test "有好的转向" do
    get edit_user_path(@user)
    log_in_as(@user)

    assert_redirected_to edit_user_path(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: {
        user: { name: name,
                email: email,
                password: "",
                password_confirmation: ""
        }
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end



























