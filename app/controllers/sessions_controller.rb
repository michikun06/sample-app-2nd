class SessionsController < ApplicationController
  def new
  end
  
  # Post /users/new
  def create
    user = User.find_by(email: params[:session][:email].downcase)     # userをDBから見つける
    if user&.authenticate(params[:session][:password])     # userの存在性、パスワードの正当性の検証(ぼっち演算子)
      if user.activated?
        log_in user
        params[:session][:remember_me] == '1' ? remember(user) : forget(user)
        redirect_back_or user
      else
        message  = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
    else
      # エラーメッセージを作成する（ログインに失敗した時）
      flash.now[:danger] = 'Invalid email/password combination'     # nowメソッドで次のリクエストが￥きた段階で消滅する。
      render 'new'
    end
  end
  
  def destroy
    log_out if logged_in?     #ログイン中のみログアウトメソッドを発動させる
    redirect_to root_url
  end
end
