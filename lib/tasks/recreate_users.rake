task recreate_users: :environment do
  ENV['PREFINERY_API_KEY'] = 'ybU9hmyw22txRChM4t8G'
  @prefinery = Prefinery.new

  def create_all
    pagination  = pagination_info
    total_pages = pagination['pages'].to_i

    (1..total_pages).each do |page|
      res     = @prefinery.tester_conn.get "?page=#{page}"
      testers = JSON.parse(res.body)
      create_testers(testers)
    end
  end

  def create_testers(testers)
    testers.each do |t|
      if User.exists?(email: t['email']) || !t['waitlist_position'].presence
        puts 'User already exists.'
        next
      end
      create_user(t)
      puts "User: #{t['email']} recreated."
    end
  end

  def create_user(tester)
    user_params = { email: tester['email'] }
    identity_params = { uid: tester['id'], provider: 'prefinery',
                        access_token: tester['waitlist_position'] }
    if tester['profile']['first_name'] && tester['profile']['last_name']
      user_params.merge(first_name: tester['profile']['first_name'])
      user_params.merge(last_name: tester['profile']['last_name'])
    end
    User.fetch_identity(identity_params, user_params)
  end

  def pagination_info
    response = @prefinery.tester_conn.get
    JSON.parse(response.headers['x-pagination'])
  end

  create_all
end
