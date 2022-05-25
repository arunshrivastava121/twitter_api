class PostsController < ApplicationController
  include CurrentUserConcern
  before_action :set_post, only: [:retweet, :destroy, :destroy_retweet]

  def index
    @posts = Post.all.includes(:comments).order(created_at: :desc)

    render json: @posts, status: 200
  end

  def create
    @post = Post.new(post_params)

    if @post.save
      render json: @post, status: :created
    else
      render json: @post.errors, status: :unprocessable_entity
    end
  end

  def retweet
    retweet = @post.retweets.create(user_id: @current_user&.id)

    if retweet.valid?
      render json: @post, status: 200
    else
      render json: retweet.errors, status: :unprocessable_entity
    end
  end

  def destroy_retweet
    retweet = @post.retweets.find_by(user_id: @current_user)&.destroy

    if retweet.present?
      render json: @post, status: 200
    else
      render json: retweet&.errors, status: :unprocessable_entity
    end
  end

  def destroy
    if @post&.destroy
      render json: {deleted: true}, status: 200
    else
      render json: {deleted: false}, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:text, :image_url, :verified, :user_id, :username)
  end

  def set_post
    @post = Post.find_by(id: params[:id])
  end
end