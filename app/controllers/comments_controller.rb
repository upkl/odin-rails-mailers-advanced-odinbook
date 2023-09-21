# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @post = Post.find(params[:post_id])
    redirect_to posts_url unless @post.user_id == current_user.id || current_user.friend_ids.include?(@post.user_id)

    @comment = @post.comments.new(user: current_user)
  end

  def create
    @post = Post.find(params[:post_id])
    redirect_to posts_url unless @post.user_id == current_user.id || current_user.friend_ids.include?(@post.user_id)

    @comment = @post.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:post_id])
    redirect_to posts_url unless @post.user_id == current_user.id || current_user.friend_ids.include?(@post.user_id)

    @comment = @post.comments.find_by(id: params[:id])
    redirect_to @post unless @comment.user_id == current_user.id
  end

  def update
    @post = Post.find(params[:post_id])
    redirect_to posts_url unless @post.user_id == current_user.id || current_user.friend_ids.include?(@post.user_id)

    @comment = @post.comments.find_by(id: params[:id])
    redirect_to @post unless @comment.user_id == current_user.id

    if @comment.update(comment_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    redirect_to posts_url unless @post.user_id == current_user.id || current_user.friend_ids.include?(@post.user_id)

    @comment = @post.comments.find_by(id: params[:id])
    @comment.destroy if @post.user_id == current_user.id || @comment.user_id == current_user.id

    redirect_to @post
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
