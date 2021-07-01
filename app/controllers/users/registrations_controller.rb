# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
   before_action :configure_sign_up_params, only: [:create]

  # before_action :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  def new
    to = Time.current.at_beginning_of_day #１週間の投稿をランダムに並び替え
    from = (to - 6.day).at_end_of_day
    weekly_post = Post.includes(:user).where(created_at: from...to).shuffle
    @posts = weekly_post.first(5)
    super
  end

  # POST /resource
  def create
        # ここでUser.new（と同等の操作）を行う
    build_resource(sign_up_params)

    # ここでUser.save（と同等の操作）を行う
    resource.save

    # ブロックが与えられたらresource(=User)を呼ぶ
    yield resource if block_given?
    if resource.persisted?
    # 先程のresource.saveが成功していたら
      if resource.active_for_authentication?
      # confirmable/lockableどちらかのactive_for_authentication?がtrueだったら
        # flashメッセージを設定
        set_flash_message! :notice, :signed_up
        # サインアップ操作
        sign_up(resource_name, resource)
        # リダイレクト先を指定
        # respond_with resource, location: after_sign_up_path_for(resource)
        redirect_to root_path #formatをHTMLに固定
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        # sessionを削除
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
    # 先程のresource.saveが失敗していたら
      # passwordとpassword_confirmationをnilにする
      clean_up_passwords resource
      # validatable有効時に、パスワードの最小値を設定する
      set_minimum_password_length
      render "error" #エラー時ののformatはJSを指定
      # respond_with resource
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

   protected

  # If you have extra params to permit, append them to the sanitizer.
   def configure_sign_up_params
     devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
   end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
   def after_sign_up_path_for(resource)
     root_path
   end

  # The path used after sign up for inactive accounts.
   def after_inactive_sign_up_path_for(resource)
     root_path
   end
end
