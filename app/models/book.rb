class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy 
  
  validates :title, presence: true
  validates :body, presence: true, length: {maximum: 200}

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  # 検索方法分岐メソッド
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end


  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }    # 今日の投稿
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }    # 前日の投稿
  scope :created_2days, -> { where(created_at: 2.days.ago.all_day) }       # 2日前の投稿
  scope :created_3days, -> { where(created_at: 3.days.ago.all_day) }       # 3日前の投稿
  scope :created_4days, -> { where(created_at: 4.days.ago.all_day) }       # 4日前の投稿
  scope :created_5days, -> { where(created_at: 5.days.ago.all_day) }       # 5日前の投稿
  scope :created_6days, -> { where(created_at: 6.days.ago.all_day) }       # 6日前の投稿
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }  # 今週の投稿数
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }  #先週の投稿数
end

