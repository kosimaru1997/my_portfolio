class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def top
    if params[:search].present?
      @users = User.search(params[:search]).page(params[:page]).reverse_order
    else
      @users = User.all.page(params[:page]).reverse_order
    end
  end
end
