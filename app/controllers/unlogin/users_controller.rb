# frozen_string_literal: true

class Unlogin::UsersController < ApplicationController
  def index
    @users = User.all.page(params[:page]).reverse_order
  end
end
