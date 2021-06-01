class Public::HomesController < ApplicationController
  
  def top
    @post = current_user.posts.build if user_signed_in?
  end
  
end
