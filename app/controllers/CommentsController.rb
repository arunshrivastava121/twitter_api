class CommentsController < ApplicationController
  before_action :set_comment, only: [:destroy]
  def index
    @comments = Comment.all.order(created_at: :desc)

    render json: @comments
  end

  def create
    @comment = Comment.new(comment_params)

    if @comment.save
      render json: @comment, status: :created
    else
      render json: @comment.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @comment&.destroy
      render json: {deleted: true}, status: 200
    else
      render json: {deleted: false}, status: :unprocessable_entity
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body, :username, :user_id, :post_id, :parent_id)
  end

  def set_comment
    @comment = Comment.find_by(params[:id])
  end
end