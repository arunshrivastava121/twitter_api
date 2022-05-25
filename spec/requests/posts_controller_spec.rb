require 'rails_helper'

RSpec.describe '/posts', type: :request do
  before(:each) do
    @user = User.create! valid_user_attributes
  end

  let(:valid_session_attributes) {
    {
      email: 'abc@gmail.com',
      password: '123456'
    }
  }

  let(:valid_user_attributes) {
    {
      name: 'abc',
      email: 'abc@gmail.com',
      password: '123456',
      password_confirmation: '123456'
    }
  }
  
  let(:valid_posts_attributes) {
    {
      text: 'valid post text',
      image_url: 'https://picsum.photos/200/300',
      verified: true,
      user_id: @user.id
    }
  }

  let(:invalid_posts_attributes) {
    {
      text: '',
      image_url: 'https://picsum.photos/200/300',
      verified: false,
      user_id: @user.id
    }
  }

  let(:post_without_user_id_attributes) {
    {
      text: 'invalid post',
      image_url: 'https://picsum.photos/200/300',
      verified: false,
      user_id: nil
    }
  }

  describe 'GET /posts', type: :request do
    it 'should return all posts' do
      @post = Post.create! valid_posts_attributes

      get '/posts'

      json = JSON.parse(response.body)

      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /posts', type: :request do
    context 'with valid parameters' do
      it 'create a new post' do
        post '/posts', params: {post: valid_posts_attributes}

        json = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(json['user_id']).to eq(@user.id)
        expect(json['text']).to eq('valid post text')
        expect(json['image_url']).to eq("https://picsum.photos/200/300")
      end

      it 'Should return one post' do
        expect(Post.count).to eq(0)
        post '/posts', params: {post: valid_posts_attributes}
         
        json = JSON.parse(response.body)
        expect(Post.count).to eq(1)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new post' do
        post '/posts', params: {post: invalid_posts_attributes}

        json = JSON.parse(response.body)

        expect(response).to have_http_status(422)
        expect(json['text']).to eq(["can't be blank"])
      end

      it "shouldn't create a new post without user id" do
        post '/posts', params: {post: post_without_user_id_attributes}

        json = JSON.parse(response.body)

        expect(response).to have_http_status(422)
        expect(json['user']).to eq(["must exist"])
      end
    end
  end

  describe 'get /retweet', type: :request do
    it 'create a new retweet' do
      @post = Post.create! valid_posts_attributes
      post '/sessions', params: {user: valid_session_attributes}

      get retweet_post_url(@post)

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(@post.retweets.count).to eq(1)
    end

    it 'user can not retweet without login' do
      @post = Post.create! valid_posts_attributes

      get retweet_post_url(@post)

      json = JSON.parse(response.body)

      expect(response).to have_http_status(422)
      expect(json['user_id']).to eq(["can't be blank"])
    end
  end

  describe 'DELETE /destroy_retweet' do
    it 'destroys the requested retweet' do
      @post = Post.create! valid_posts_attributes
      @retweet = @post.retweets.create user_id: @user.id
      post '/sessions', params: {user: valid_session_attributes}
      expect(@post.retweets.count).to eq(1)

      delete destroy_retweet_post_url(@post)

      expect(response).to have_http_status(:ok)
      expect(@post.retweets.count).to eq(0)
    end

    it 'user cannot able to retweet without login' do
      @post = Post.create! valid_posts_attributes
      @retweet = @post.retweets.create user_id: @user.id
      expect(@post.retweets.count).to eq(1)

      delete destroy_retweet_post_url(@post)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(@post.retweets.count).to eq(1)
    end
  end

  describe 'DELETE /destroy', type: :request do
    it 'destroys the requested Post' do
      @post = Post.create! valid_posts_attributes
      delete post_url(id: @post)

      json = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(json['deleted']).to eq(true)
    end

    it 'does not destroy the requested post' do
      delete post_url(id: 0)

      json = JSON.parse(response.body)

      expect(response).to have_http_status(422)
      expect(json['deleted']).to eq(false)
    end
  end
end