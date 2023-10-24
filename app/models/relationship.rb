class Relationship < ApplicationRecord
  # class_name: "User"でUserモデルを参照
  # belongs_to :user　と指定すると、どっちがどっちのuserかわからなくなるため
  # follower, followedで分けてあげる
  # しかし、そのままだとfollower, followedテーブルを探しに行くので、
  # class_name: "User"とすることで、userテーブルからデータを取ってくるようにする。
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  validates_uniqueness_of :follower_id, scope: :followed_id
end
