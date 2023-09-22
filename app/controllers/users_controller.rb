# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = if params[:id]
              User.find(params[:id])
            else
              current_user
            end

    id = params[:id].to_i

    @friendship = if @user == current_user
                    nil
                  elsif current_user.friend_ids.include?(id)
                    :friend
                  elsif current_user.friend_requests_received.pending.map(&:sender_id).include?(id)
                    :acceptable
                  elsif current_user.friend_requests_sent.pending.map(&:receiver_id).include?(id)
                    :pending
                  elsif current_user.friend_requests_sent.rejected.map(&:receiver_id).include?(id)
                    :rejecting
                  else
                    :invitable
                  end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if @user.update(user_params)
      redirect_to current_user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def index
    @users = User.all.reject { |u| u == current_user } # .includes(:friend_requests_sent, :friend_requests_received)
    @acceptable_users = current_user.friend_requests_received.pending.map(&:sender)
    @rejecting_users = current_user.friend_requests_sent.rejected.map(&:receiver)
    @pending_users = current_user.friend_requests_sent.pending.map(&:receiver)
    @friends = current_user.friends
  end

  private

  def user_params
    params.require(:user).permit(:name, :city, :dish)
  end
end
