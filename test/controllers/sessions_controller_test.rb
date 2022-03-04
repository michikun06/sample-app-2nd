require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  
  # 名前付きルートを使用可能にする
  test "should get new" do
    get login_path
    assert_response :success
  end

end
