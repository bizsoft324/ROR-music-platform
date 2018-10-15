module SessionParams
  def twitter_identity_params
    { provider: auth_hash['provider'],
      avatar_url: auth_hash['info']['image'],
      uid: auth_hash['uid'],
      access_token: auth_hash['credentials']['token'] }
  end

  def remove_empty_values(params)
    params.delete_if { |_key, value| value.blank? }
  end

  def twitter_user_params
    { username: auth_hash['info']['nickname'],
      first_name: name_split.first,
      last_name: name_split.last,
      remote_avatar_url: auth_hash['info']['image'],
      email: auth_hash['info']['email'],
      confirmed: true }
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def name_split
    auth_hash['info']['name'].split(' ')
  end

  def sign_in(user)
    if params[:remember_me]
      cookies.permanent[:auth_token] = user.auth_token
    else
      cookies[:auth_token] = user.auth_token
    end
  end
end
