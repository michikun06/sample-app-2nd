class UsersController < ApplicationController
  
  # Get /users/:id/show
  def show
    @user = User.find(params[:id])
  end
  
  # Get /users/new
  def new
    @user = User.new
  end
  
  # Post /users/new
  def create
    @user = User.new(user_params)
    if @user.save
      # 保存の成功をここで扱う。
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
