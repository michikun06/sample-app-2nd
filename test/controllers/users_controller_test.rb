require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @non_activated_user = users(:non_activated)
  end

  test "should get new" do
    get signup_path
    assert_response :success
  end
  
  # ログインせずに/usersにGetリクエスト → ログインページへリダイレクトするかのテスト
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end
  
  # ログインせずに/users/:id/editにGetリクエストを送る
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  # ログインせずに/users/:id/editにPatchリクエストを送る
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  # admin属性の変更が禁止されていることをテストする
  test "should not allow the admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "password",
                                            password_confirmation: "password",
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end
  
  # archerでログインしてmichaelの情報の編集画面に行こうとした時にエラーを出すか確認するテスト
  test "should redirect edit when logged in as wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  # archerでログインしてmichaelの情報の直接編集しようとした時にエラーを出すか確認するテスト
  test "should redirect update when logged in as wrong user" do
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end
  
  # ログインしていないユーザーがdeleteリクエストを送った時にlogin_urlにリダイレクトされるかのテスト
  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end
  
  # admin権限を持っていないユーザーがdeleteリクエストを送った時にroot_urlにリダイレクトされるかのテスト
  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
  
  # 認証が終わっていない（有効化されていない）ユーザーを非表示にしているかのテスト
  test "should not allow the not activated attribute" do
    log_in_as(@non_activated_user)
    assert_not @non_activated_user.activated?
    get users_path
    assert_select "a[href=?]", user_path(@non_activated_user), count: 0
    get user_path(@non_activated_user)
    # assert_redirected_to root_url
  end
  
  test "should redirect following when not logged in" do
    get following_user_path(@user)
    assert_redirected_to login_url
  end

  test "should redirect followers when not logged in" do
    get followers_user_path(@user)
    assert_redirected_to login_url
  end

end