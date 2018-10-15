class BaseMailer < ActionMailer::Base
  add_template_helper(EmailHelper)
end
