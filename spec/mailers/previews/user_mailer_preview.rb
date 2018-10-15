class UserMailerPreview < ActionMailer::Preview
  def confirmation
    UserMailer.confirmation(User.first, ActiveSupport::MessageVerifier.new('test string'))
  end

  def reset_password
    UserMailer.reset_password(User.first)
  end

  def waitlist_confirmation_email
    UserMailer.waitlist_confirmation_email(User.first)
  end

  def waitlist_success_email
    UserMailer.waitlist_success_email(User.first)
  end

  def charted
    UserMailer.charted(Track::Charted.first)
  end

  def top_ten
    UserMailer.top_ten(Track::Charted.first)
  end

  def charts_update
    UserMailer.charts_update(User.find(15))
  end

  def critique_notification
    UserMailer.critique_notification(Comment.first)
  end
end
