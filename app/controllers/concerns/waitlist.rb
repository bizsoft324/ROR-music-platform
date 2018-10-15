module Waitlist
  def prefinery_tester
    tester = new_tester
    identity_params = {
      uid: tester['id'],
      provider: 'prefinery',
      access_token: tester['waitlist_position'].to_s # needed for identity + useful for mailer
    }
    user = User.fetch_identity(identity_params, user_params)
    Prefinery.send_confirmation(user)
  end

  def new_tester
    id = session[:referrer_id]
    Prefinery.create_tester(email: user_params[:email], user_agent: params[:user_agent], referrer_id: id)
  end
end
