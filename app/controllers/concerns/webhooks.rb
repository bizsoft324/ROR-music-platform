module Webhooks
  extend ActiveSupport::Concern

  # sends a message to slack #btactivity channel with (message).
  def slack_notify(message = '')
    Slack::Notifier.new(ENV['WEBHOOK_URL']).ping(message) unless Rails.env.development?
  end
end
