class Group < ApplicationRecord
# グループ機能
  has_many :group_users, dependent: :destroy
  belongs_to :owner, class_name: 'User'
  has_many :users, through: :group_users
  
  validates :name, presence: true
  validates :introduction, presence: true
  has_one_attached :image

  def get_image(width, height)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/monbo.jpeg')
      image.attach(io: File.open(file_path), filename: 'monbo.jpeg', content_type: 'image/jpeg')
    end
    image.variant(resize_to_limit: [width, height]).processed
  end



#オーナーかどうかチェック
  def is_owned_by?(user)
      owner.id == user.id
  end
end
