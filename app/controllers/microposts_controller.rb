class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy
  
  # POST /microposts
  def create
    @micropost = current_user.microposts.build(micropost_params)     # user_idが紐づいたmicropostを取得してインスタンス変数に格納
    @micropost.image.attach(params[:micropost][:image])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end
  
  # DELETE /microposts/:id
  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_back(fallback_location: root_url)
    # redirect_to request.referrer || root_url
  end


  private

    def micropost_params
      params.require(:micropost).permit(:content, :image)
    end

    # 投稿したユーザーと現在ログインしているユーザーが同じであればパス。そうでなければroot_urlへ
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end