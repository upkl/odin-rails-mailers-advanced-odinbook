# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    friend_ids = current_user.friend_ids
    @posts = Post.all
                 .filter { |post| post.user_id == current_user.id || friend_ids.include?(post.user_id) }
                 .sort_by(&:updated_at).reverse
  end

  def show
    @post = Post.find(params[:id])
    redirect_to posts_url unless @post.user_id == current_user.id || current_user.friend_ids.include?(@post.user_id)
  end

  def new
    @post = current_user.posts.new
  end

  def create
    @post = current_user.posts.new(post_params)

    if @post.save
      redirect_to posts_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @post = Post.find(params[:id])
    redirect_to @post unless @post.user_id == current_user.id
  end

  def update
    @post = Post.find(params[:id])
    redirect_to @post unless @post.user_id == current_user.id

    if @post.update(post_params)
      redirect_to @post
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy if post.user_id == current_user.id

    redirect_to posts_url
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
