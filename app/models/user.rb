class User < ApplicationRecord
  #继承 ActiveRecord::Base 类,模型对象才能与数据库通讯,才
  #能把数据库中的列看做 Ruby 中的属性,
  #rails generate scaffold User name:string email:string
  has_many :microposts
  validates :name,presence: true #name必须存在
  validates :emails,presence: true
end
