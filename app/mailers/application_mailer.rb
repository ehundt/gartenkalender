class ApplicationMailer < ActionMailer::Base
  default from: "localhost"
  layout 'mailer'
end
