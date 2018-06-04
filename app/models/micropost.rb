class Micropost < ApplicationRecord
  #rails generate scaffold Micropost content:text user_id:integer
  validates :content,length: {maximum: 140},
            presence: true #验证微博内容必须存在   presence：存在，出席，仪表，风度，鬼魂
  belongs_to :user
end
