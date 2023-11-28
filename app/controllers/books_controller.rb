class BooksController < ApplicationController
    before_action :is_matching_login_user, only: [:edit]
  def index
    @book = Book.new
    if params[:latest]
      @books = Book.latest
    elsif params[:old]
      @books = Book.old
    elsif params[:star_count]
      @books = Book.star_count
    else
      @books = Book.all
    end
  end

  def show
    @book_new = Book.new
    @books = Book.all
    @book = Book.find(params[:id])
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
    params.require(:book).permit(:title, :body, :image, :star)
  end

  def is_matching_login_user
    book = Book.find(params[:id])
    unless book.user_id == current_user.id
      redirect_to books_path
    end
  end

end
