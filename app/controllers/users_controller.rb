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
