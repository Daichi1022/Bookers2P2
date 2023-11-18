class BooksController < ApplicationController
    before_action :is_matching_login_user, only: [:edit]
  def index
    @book = Book.new
    to  = Time.current.at_end_of_day   #現在の時間を取得、その日の終わりを設定
    from  = (to - 6.day).at_beginning_of_day #ビギニングオブデイ　　現在の日の終わりから6日前の時間範囲を計算してその日の始まりを設定
    @books = Book.includes(:favorites).sort_by {|book| book.favorites.where(created_at: from...to).size}.reverse 
             #Bookと関連するテーブル(:favorites)をまとめて取得。　　　いいねのついた本を探す　過去一週間　　　降順（お気に入りが多い方から少ない方へ）
    @book = Book.new
  end

  def show
    @book_new = Book.new
    @books = Book.all
    @book = Book.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
    @book_comment = BookComment.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      flash[:notice] = "You have created book successfully."
      redirect_to book_path(@book)
    else
      @books = Book.all
      render :index
    end
  end

  def update
    @book = Book.find(params[:id])
  if @book.update(book_params)
    flash[:notice] = "You have updated book successfully."
    redirect_to book_path(@book)
  else
    render :edit
  end
  end

    def destroy
      book = Book.find(params[:id])
      book.destroy
      redirect_to books_path
    end


  private

  def book_params
    params.require(:book).permit(:title, :body, :image)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user_id == current_user.id
      redirect_to books_path
    end
  end

end
