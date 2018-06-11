class User < ApplicationRecord
  attr_accessor :remember_token
  has_secure_password  #会在password 和 password_confirmation上执行验证

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  #before_save { self.email=email.downcase}
  before_save {email.downcase!} #上一行代码的一种优雅的写法
  validates :name,presence: true,length: {maximum: 50}
  validates :email,
            presence: true,# 不可为空！
            length: {maximum: 255},
            format: {with: VALID_EMAIL_REGEX}, #格式，需匹配“VALID_EMAIL_REGEX”这个正则表达式
            uniqueness: {case_sensitive: false} #不可重复且大小写不敏感
            #uniqueness: true #不可重复，默认大小写敏感
            #假如有两个用户，同时使用相同的邮箱注册，可能出现这样的情况：
            # 由于两个User类对象都还在内存中，因此这两个对象的vaild?方法的返回值均为true
            # 这样两者依旧可以执行save，导致数据库中出现两个相同的email
            # 解决方案：在数据库上加索引，让数据库中的email唯一
            # rails generate migration add_index_to_users_email
            # rails db:migrate

  validates :password,
            length: {minimum: 6}

  # 返回指定字符串的哈希摘要
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
               BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
  # 返回一个随机令牌
  def User.new_token
    SecureRandom.urlsafe_base64
  end


  def remember
    #必须要有self,否则创建的是一个本地变量
    self.remember_token =User.new_token   #生成一个随机令牌（token）,
    #将生成的这个随机令牌的哈希值存入数据库中
    # 下次登录时，从
    update_attribute(:remember_digest, User.digest(remember_token))
  end


  # 如果指定的令牌和摘要匹配,返回 true
  # 这里的remember_token是方法里的参数，是的局部变量，而不是类中的属性
  # 用于检测自身的remember_digest属性与参数中的remember_token是否匹配
  def authenticated?(remember_token)
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
end
