class UsersController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @users = User.all
    @friends = current_user.followers & current_user.followed_users
  end
  def show
    @user = User.find(params[:id])
    @topics = Topic.order(:created_at).reverse_order
    @friends = current_user.followers & current_user.followed_users
  end
end
