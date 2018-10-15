module RandomString
  def random_string(length)
    chars = 'abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ23456789'
    body = ''
    length.times { body << chars[rand(chars.size)] }
    body.to_s
  end
end
