class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]

  def show
    @book = Book.find(params[:id])
    @book_new = Book.new
    @book_comment = BookComment.new
    impressionist(@book, nil, unique: [:ip_address])#応用課題9aの追記
  end

  def index
    to = Time.current.at_end_of_day
    from = (to - 6.day).at_beginning_of_day
    @books = Book.includes(:favorited_users).
      sort {|a,b|
        b.favorited_users.includes(:favorites).where(created_at: from...to).size <=>
        a.favorited_users.includes(:favorites).where(created_at: from...to).size
      }
    @user = current_user
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user = current_user
    if params[:book]
      if @book.save(context: :publicize)
        redirect_to book_path(@book), notice: "You have created book successfully."
      else
        @books = Book.all
        render 'index'
      end
    else
      if @book.update(is_draft: true)
        redirect_to user_path(current_user), notice: "下書き保存しました"
      else
        render 'index'
      end
    end
    # if @book.save
    #   redirect_to book_path(@book), notice: "You have created book successfully."
    # else
    #   @books = Book.all
    #   render 'index'
    # end
  end

  def edit
    @book = Book.find(params[:id])
    @user = User.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if params[:publicize_draft]
      @book.attributes = book_params.merge(is_draft: false)
      if @book.save(context: :publicize)
        redirect_to book_path(@book.id), notice: "下書きを公開しました"
      else
        @book.is_draft = true
        render :edit, alert: "下書きを公開できませんでした"
      end
    elsif params[:update_book]
      @book.attributes = book_params
      if @book.save(context: :publicize)
        redirect_to book_path(@book.id), notice: "投稿を更新しました"
      else
        render :edit, alert: "更新に失敗しました"
      end
    else
      if @book.update(book_params)
        redirect_to book_path(@book.id), notice: "下書きを更新しました"
      else
        render :edit, alert: "更新できませんでした"
      end
    end
    # if @book.update(book_params)
    #   redirect_to book_path(@book.id), notice: "You have updated book successfully."
    # else
    #   render "edit"
    # end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path, notice: "successfully delete book!"
  end

  private

  def book_params
    params.require(:book).permit(:title, :body, :is_draft)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
     redirect_to books_path
    end
  end
end
