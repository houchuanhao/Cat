require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  # Add more helper methods to be used by all tests here...
  def setup
    @user = User.new(name: "Example User", email: "user@example.com",password: "foobar", password_confirmation: "foobar")
  end
  test "should be valid" do
    assert @user.valid?
  end
  test "name should be persent" do
    @user.name=""
    assert_not @user.valid?
  end
  test "email should be present" do
    @user.email=""
    assert_not @user.valid?
  end
  test "name should be too long" do
    @user.name="a"*51
    assert_not @user.valid?
  end
  test "email should be too long" do
    @user.email="e"*244+ "@example.com"
    assert_not @user.valid?
  end
#测试一下，看看这几个邮箱是否合法 user@example.com USER@foo.COM A_US-ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn
  test "email validation should accept valid addresses" do
    valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  test "email address should be unique" do
    duplicate_user=@user.dup
    @user.save
    assert_not duplicate_user.valid?
  end
  test "存入的email都是小写" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email=mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase,@user.reload.email
  end
  test "密码最短长度为6" do
    @user.password=@user.password_confirmation="a"*5
    assert_not @user.valid?
  end
end
