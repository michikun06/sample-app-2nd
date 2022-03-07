class PasswordResetsController < ApplicationController
  before_action :get_user,   only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]    # （1）への対応
  
  def new
  end
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest     # トークン生成、ダイジェストに保存、ユーザーに送信までする。
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end
  
  # GET  /password_resets/:id:edit
  def edit
    # default render
    # app/views/password_resets/edit.html.erb
  end
  
  # PATCH /password_resets/:id:edit
  def update
    if params[:user][:password].empty?                  # （3）への対応
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)                     # （4）への対応
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'                                     # （2）への対応
    end
  end
  
  # パスワードの再設定が完了したらダイジェストをnilにする
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update(user_params)
      log_in @user
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  
  private
  
  
    # Strong Parameter
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end

    # 正しいユーザーかどうか確認する処理をメソッド化する。(:edit, :updateアクションの前に実行)
    def valid_user
      # ① ユーザーが存在しているか
      # ② 認証済みのユーザーか
      # ③ トークンが正しいものかどうか
      # 一つでもtrue以外があればroot_urlへ
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has expired."
        redirect_to new_password_reset_url
      end
    end
end
