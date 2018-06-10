module UsersHelper
  def gravatar_for(user,options = { size: 80 })
    size=options[:size]
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    return image_tag(gravatar_url, alt: user.name, class: "gravatar") #返回一个image_tag类型的视图
  end
end
