class BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @comment = current_user.book_comments.new(book_comment_params)
    @commen.book_id = book_id
    @comment.save
    redirect_to book_path(@book)
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  ends
end
