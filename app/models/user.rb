class User < ApplicationRecord
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
end
