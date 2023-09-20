class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = if params[:id]
              User.find(params[:id])
            else
              current_user
            end
  end

  def index
    @users = User.all
  end
end
