class AccountActivationsController < ApplicationController
  
  # GET /account_activations/:id/edit
  def edit
    user = User.find_by(email: params[:email])     # URLからemailを引っ張ってきてDBを検索する。
    if user && !user.activated? && user.authenticated?(:activation, params[:id])     # nilガード and アクティベートされてないかトークンが正しいかチェック、
      user.activate
      log_in user     # ログイン
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
