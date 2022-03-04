require 'test_helper'

class SessionsHelperTest < ActionView::TestCase

  def setup
    @user = users(:michael)     # fixtureでuser変数を定義する
    remember(@user)     # 渡されたユーザーをrememberメソッドで記憶する
  end
  
  # ログイン状態であることのテスト
  test "current_user returns right user when session is nil" do
    assert_equal @user, current_user
    assert is_logged_in?
  end
  
  # ログアウト状態であることのテスト
  test "current_user returns nil when remember digest is wrong" do
    @user.update_attribute(:remember_digest, User.digest(User.new_token))
    assert_nil current_user
  end
end
