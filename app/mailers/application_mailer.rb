# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@upkl.example'
  layout 'mailer'
end
