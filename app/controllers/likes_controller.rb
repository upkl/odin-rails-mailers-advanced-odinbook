# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])

    like = post.likes.new(user: current_user)

    if like.save
      redirect_to post
    else
      render post, status: :unprocessable_entity
    end
  end

  def destroy
    post = Post.find(params[:post_id])

    like = post.likes.find_by(user: current_user)

    like.destroy

    redirect_to post
  end
end
