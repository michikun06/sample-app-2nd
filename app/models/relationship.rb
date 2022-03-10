class Relationship < ApplicationRecord
  
  # Relationshipクラスのオブジェクトに対してfollowerメソッドを呼び出すとfollower_idに格納されているidを保持しているユーザーをUserクラスから取得する
  belongs_to :follower, class_name: "User"     # follower_idにUserクラスのidを紐づける事を明示的に指定する。
  # 規約(defaultの挙動)  "モデル名_id" => Follower_id
  
  belongs_to :followed, class_name: "User"     # followed_idにUserクラスのidを紐づける事を明示的に指定する。
  # 規約(defaultの挙動)  "モデル名_id" => Follower_id
  
  validates :follower_id, presence: true
  validates :followed_id, presence: true
end