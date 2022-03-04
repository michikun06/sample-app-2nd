class SessionsController < ApplicationController
  def new
  end
  
  # Post /users/new
  def create
    user = User.find_by(email: params[:session][:email].downcase)     # userをDBから見つける
    if user&.authenticate(params[:session][:password])     # userの存在性、パスワードの正当性の検証(ぼっち演算子)
      # ユーザーログイン後にユーザー情報のページにリダイレクトする
      log_in user
      redirect_to user
    else
      # エラーメッセージを作成する（ログインに失敗した時）
      flash.now[:danger] = 'Invalid email/password combination'     # nowメソッドで次のリクエストが￥きた段階で消滅する。
      render 'new'
    end
  end
  
  def destroy
    log_out
    redirect_to root_url
  end
end
