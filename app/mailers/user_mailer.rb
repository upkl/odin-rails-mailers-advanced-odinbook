# frozen_string_literal: true

class UserMailer < ApplicationMailer
  def welcome_email
    @user = params[:user]
    @url = 'http://localhost:3000/'
    mail(to: @user.email, subject: 'Welcome to Odinbook')
  end
end
