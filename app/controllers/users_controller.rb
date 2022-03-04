class UsersController < ApplicationController
  # index、edit、updateアクションが発動する前に、logged_in_userメソッドをを呼び出す
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  
  # edit、updateアクションが発動する前に、correct_userメソッドをを呼び出す
  before_action :correct_user,   only: [:edit, :update]
  
  # destroyアクションが発動する前に、admin_userメソッドをを呼び出す
  before_action :admin_user,     only: :destroy
  
  # GET /users
  def index
    @users = User.paginate(page: params[:page])
  end
  
  # GET /users/:id/show
  def show
    @user = User.find(params[:id])
  end
  
  # GET /users/new
  def new
    @user = User.new
  end
  
  # POST /users/new
  def create
    @user = User.new(user_params)
    if @user.save
      # 保存の成功をここで扱う。
      log_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
  end
  
  # PATCH  /users/:id/edit
  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      # 更新に成功した場合を扱う。
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    # ログイン済みユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location     # アクセスしようとしたURLを覚えておくメソッド(app/helper/sessions_helper.rb)
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
