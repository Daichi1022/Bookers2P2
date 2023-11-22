class UsersController < ApplicationController
    before_action :is_matching_login_user, only: [:edit]
   def index
    @book = Book.new
    @users = User.all

   end

   def show
    @user = User.find(params[:id])
    @book = Book.new
    @books = @user.books
    @today_book =  @books.created_today     #本日の投稿
    @yesterday_book = @books.created_yesterday   #昨日の投稿
    @this_week_book = @books.created_this_week   #今週の投稿
    @last_week_book = @books.created_last_week    #先週の投稿
   end

   def edit
    @user = User.find(params[:id])
   end

   def update
    @user = User.find(params[:id])
     if @user.update(user_params)
      flash[:notice] = "You have updated user successfully."
      redirect_to user_path(current_user)
     else
      render :edit
     end
   end

   def posts_on_date
      # リクエストの中からユーザーIDを取得し、データベースからユーザー情報とを取得　 #Userと関連するテーブル(:books)をまとめて取得。　インクルーズ
      user = User.includes(:books).find(params[:user_id])
      # リクエストの中から指定された日付を取得し、日付オブジェクトに変換
      date = Date.parse(params[:created_at])
      # ユーザーが指定した日に投稿した本（books）をデータベースから検索　　　all_dayは一日中
      @books = user.books.where(created_at: date.all_day) 
      byebug
      # 検索結果を表示するためのビュー（posts_on_date_form）にデータを送る
      render :posts_on_date_form
   end

  private

   def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
   end

   def is_matching_login_user
    user = User.find(params[:id])
     unless user.id == current_user.id
      redirect_to user_path(current_user)
     end
   end
end
