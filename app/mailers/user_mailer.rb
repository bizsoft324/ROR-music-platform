class UserMailer < BaseMailer
  default from: 'team@beatthread.com'

  def confirmation(user, token)
    @user = user
    @confirm_token = token
    email = mail to: user.email, subject: 'Welcome to BeatThread'
    email.mailgun_variables = { user: @user, confirm_token: @confirm_token }
  end

  def reset_password(user)
    @user = user
    email = mail to: user.email
    email.mailgun_variables = { user: @user }
  end

  def waitlist_confirmation_email(user)
    @position = user.position
    @url      = Shortener::ShortenedUrl.generate("/waitlist/#{user.token}/activate")
    email = mail to: user.email, subject: "Spot ##{@position} on the BeatThread Beta needs to be confirmed!"
    email.mailgun_variables = { position: @position, url: @url }
  end

  def waitlist_success_email(user)
    @position = user.position
    email = mail(to: user.email, subject: "Congrats! You're ##{@position} on the BeatThread Beta!")
    email.mailgun_variables = { position: @position }
  end

  def critique_notification(comment)
    @track = comment.commentable
    @user = @track.user
    @comment = comment
    email = mail to: @user.email, subject: 'New beat critique!'
    email.mailgun_variables = { user: @user, track: @track, comment: @comment }
  end

  def charted(track_charted)
    @position = track_charted.position
    @track = track_charted.track
    @user = @track.user
    email = mail to: @user.email, subject: 'Your track has made the charts!!'
    email.mailgun_variables = { user: @user, track: @track, position: @position }
  end

  def top_ten(track_charted)
    @position = track_charted.position
    @track = track_charted.track
    @user = @track.user
    email = mail to: @user.email, subject: 'Your track is in the top ten!'
    email.mailgun_variables = { user: @user, track: @track, position: @position }
  end

  def charts_update(user)
    @user = user
    @data = @user.email_data
    email = mail to: @user.email, subject: 'Your daily charts update!'
    email.mailgun_variables = { user: @user, track: @track, position: @position }
  end
end
