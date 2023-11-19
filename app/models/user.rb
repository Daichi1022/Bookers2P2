class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image


  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/monbo.jpeg')
      profile_image.attach(io: File.open(file_path), filename: 'monbo.jpeg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

# Userモデルに関連するフォロー・フォロワー機能の定義

# フォローされているユーザーに対する関連付け
# Relationshipモデルのfollowed_idカラムを参照して、逆方向の関連を持つ
has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
# 上記の関連を経由して、実際にフォローしているユーザー情報を取得
has_many :followers, through: :reverse_of_relationships, source: :follower

# フォローしているユーザーに対する関連付け
# Relationshipモデルのfollower_idカラムを参照して、関連を持つ
has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
# 上記の関連を経由して、実際にフォローされているユーザー情報を取得
has_many :followings, through: :relationships, source: :followed

# ユーザーをフォローするメソッド
# @param [User] user - フォローするユーザー
# @return [Relationship] - 作成されたフォロー関係
def follow(user)
  relationships.create(followed_id: user.id)
end

# ユーザーのフォローを解除するメソッド
# @param [User] user - フォローを解除するユーザー
# @return [Relationship, nil] - 削除されたフォロー関係、またはnil
def unfollow(user)
  relationships.find_by(followed_id: user.id)&.destroy
end

# 指定したユーザーをフォローしているか確認するメソッド
# @param [User] user - チェック対象のユーザー
# @return [Boolean] - フォローしている場合はtrue、それ以外はfalse
def following?(user)
  followings.include?(user)
end

# 検索方法分岐用メソッド
def self.looks(search, word)
  if search == "perfect_match"
    @user = User.where("name LIKE?", "#{word}")
  elsif search == "forward_match"
    @user = User.where("name LIKE?","#{word}%")
  elsif search == "backward_match"
    @user = User.where("name LIKE?","%#{word}")
  elsif search == "partial_match"
    @user = User.where("name LIKE?","%#{word}%")
  else
    @user = User.all
  end
end

  validates :name, uniqueness: true, length: {minimum: 2, maximum: 20}
  validates :introduction, length: {maximum: 50}
end
