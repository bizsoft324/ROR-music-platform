require 'json'
require 'digest/sha1'
class Prefinery
  def initialize
    @beta_id        = 8143
    @subdomain      = 'beatthread'
    @key            = ENV['PREFINERY_API_KEY']
    @invite_secret  = ENV['PREFINERY_SECRET']
    @base_url       = "https://#{@subdomain}.prefinery.com/api/v2/betas/#{@beta_id}"
  end

  def self.create_tester(email:, user_agent:, referrer_id: nil)
    new.create_tester(email: email, user_agent: user_agent, referrer_id: referrer_id)
  end

  def self.confirm_tester(user)
    new.confirm_tester(user)
  end

  def self.total_waiting
    (new.total_waiting || 0) + 8035
  end

  def self.send_confirmation(user)
    user.generate_token('token')

    return unless user.save!(validate: false)

    UserMailer.waitlist_confirmation_email(user).deliver_later
  end

  def self.get_tester_share_link(user)
    new.get_tester_share_link(user)
  end

  def create_tester(email:, user_agent:, referrer_id:)
    params = { email: email, status: 'applied', referrer_id: referrer_id.to_i }
    tester_params = params.merge(profile: { user_agent: user_agent })

    json = { tester: tester_params }.to_json

    response = tester_conn.post do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = json
    end

    JSON.parse(response.body)
  end

  def total_waiting
    response = JSON.parse(beta_conn.get.body)
    response['testers_count']
  end

  def confirm_tester(user)
    confirm_user(user)

    identity      = user.identities.where(provider: 'prefinery').first
    tester_params = { tester: { status: 'active', invitation_code: identity.access_token_secret } }

    response = tester_conn(identity.uid).put do |req|
      req.headers['Content-Type'] = 'application/json'
      req.body = tester_params.to_json
    end
    JSON.parse(response.body)
  rescue
    false
  end

  def confirm_user(user)
    identity = user.identities.where(provider: 'prefinery').first
    identity.access_token_secret = generate_invite_code(user.email)

    return unless identity.save!

    user.confirmed = true
    user.save!(validate: false)
  end

  def generate_invite_code(email)
    Digest::SHA1.hexdigest("#{ENV['PREFINERY_SECRET']}#{email}")[0, 10]
  end

  def tester_conn(tester_id = nil)
    if tester_id
      Faraday.new(url: "#{@base_url}/testers/#{tester_id}.json?api_key=#{@key}")
    else
      Faraday.new(url: "#{@base_url}/testers.json?api_key=#{@key}")
    end
  end

  def beta_conn
    Faraday.new(url: "#{@base_url}.json?api_key=#{@key}")
  end

  def invite_user(sender_email, recipient_email)
    f = Faraday.new(url: "#{@base_url}/friend_invitations.json?api_key=ybU9hmyw22txRChM4t8G")
    f.response :logger
    f.post do |req|
      req.headers['Accept'] = 'application/json'
      req.headers['Content-Type'] = 'application/json'
      req.body = { "sender_email": sender_email, "recipient_email": recipient_email }.to_json
    end
  end

  def get_tester(user)
    response = Faraday.new("#{@base_url}/testers/#{user.tester_id}.json?api_key=#{@key}").get
    JSON.parse(response.body)
  end

  def get_tester_by_uid(uid)
    response = Faraday.new("#{@base_url}/testers/#{uid}.json?api_key=#{@key}").get
    JSON.parse(response.body)
  end

  def get_tester_invites_count(user)
    response = Faraday.new("#{@base_url}/#{@beta_id}/testers/#{user.tester_id}.json?api_key=#{@key}").get
    JSON.parse(response.body)['friend_invitations_count']
  end

  def get_tester_referral_signups_count(user)
    response = Faraday.new("#{@base_url}/testers/#{user.tester_id}.json?api_key=#{@key}").get
    JSON.parse(response.body)['share_signups_count']
  end

  def get_tester_share_link(user)
    response = Faraday.new("https://#{@subdomain}.prefinery.com/api/v2/betas/#{@beta_id}/testers/#{user.tester_id}.json?api_key=#{@key}").get
    JSON.parse(response.body)['share_link']
  end
end
