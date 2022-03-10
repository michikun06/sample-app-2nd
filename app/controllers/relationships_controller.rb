class RelationshipsController < ApplicationController
  before_action :logged_in_user
  
  # POST /relationships
  def create
    @user = User.find(params[:followed_id])
    current_user.follow(@user)     # ログインしている人が現在いる人のページのIDをURLから取得してフォローする
    # respond_to メソッドリクエストによってhtmlかjsかを使い分ける
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
  
  # POST /relationships/:id
  def destroy
    @user = Relationship.find(params[:id]).followed     # URLからその人をフォローしているリレーションシップを取得
    current_user.unfollow(@user)     # 現在ログインしている人がuserをアンフォローする
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
