# frozen_string_literal: true

class FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    receiver = User.find(params[:id])

    request = FriendRequest.new(sender: current_user, receiver:, status: :pending)

    if request.save
      redirect_to target
    else
      render target, status: :unprocessable_entity
    end
  end

  def update
    status = case params['status']
             when 'accepted'
               :accepted
             when 'rejected'
               :rejected
             end

    if status
      sender = User.find(params[:id])
      request = FriendRequest.find_by(sender:, receiver: current_user)
      if request.update(status:)
        redirect_to target
      else
        render target, status: :unprocessable_entity
      end
    else
      render target, status: :unprocessable_entity
    end
  end

  def destroy
    other = User.find(params[:id])

    request = FriendRequest.find_by(sender: current_user, receiver: other) ||
              FriendRequest.find_by(sender: other, receiver: current_user)

    request.destroy

    redirect_to target
  end

  def target
    if params[:target] == 'users#show'
      receiver
    elsif params[:target] == 'users#index'
      User
    else
      User
    end
  end
end
