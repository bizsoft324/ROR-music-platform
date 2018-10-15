class SlackNotifierJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Slack::Notifier.new(ENV['WEBHOOK_URL']).ping(args[0][:message]) unless Rails.env.development? || Rails.env.test?
  end
end
