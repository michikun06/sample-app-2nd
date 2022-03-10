require 'test_helper'

class RelationshipsControllerTest < ActionDispatch::IntegrationTest
  
  # 認可が降りているか（アクセス制限が機能しているか）のテスト
  
  # relationships_pathにpostリクエストを送ろうとしたらlogin_urlへ
  test "create should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      post relationships_path
    end
    assert_redirected_to login_url
  end

  test "destroy should require logged-in user" do
    assert_no_difference 'Relationship.count' do
      delete relationship_path(relationships(:one))
    end
    assert_redirected_to login_url
  end
end