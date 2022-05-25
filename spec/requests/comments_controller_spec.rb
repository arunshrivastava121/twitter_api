require 'rails_helper'

RSpec.describe '/comments', type: :request do
  before(:each) do
    @user = User.create! valid_user_attributes
    @post = Post.create! valid_posts_attributes
    @comment = Comment.create! valid_comment_attributes
  end

  let(:valid_comment_attributes) {
    {
      body: 'valid comment',
      username: @user.name,
      user_id: @user.id,
      post_id: @post.id
    }
  }

  let(:invalid_comment_attributes) {
    {
      body: '',
      username: @user.name,
      user_id: @user.id,
      post_id: @post.id
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

  describe 'GET /comments', type: :request do
    it 'should return all the comments' do
      get '/comments'

      json = JSON.parse(response.body)

      expect(response).to be_successful
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /comments', type: :request do
    context 'with valid parameters' do
      it 'should create a new comment' do
        post '/comments', params: {comment: valid_comment_attributes}

        json = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(json['body']).to eq('valid comment')
      end

      it 'should return one comment' do
        post '/comments', params: {comment: valid_comment_attributes}

        json = JSON.parse(response.body)

        expect(response).to have_http_status(:created)
        expect(Comment.count).to eq(2)
      end
    end

    context 'with invalid parameters' do
      it 'passing invalid attributes' do
        post '/comments', params: {comment: invalid_comment_attributes}

        json = JSON.parse(response.body)

        expect(response).to have_http_status(422)
        expect(json['body']).to eq(["can't be blank"])
      end

      it 'passing invalid username' do
        invalid_comment_attributes[:body] = 'comment!!!'
        invalid_comment_attributes[:username] = ''
        post '/comments', params: {comment: invalid_comment_attributes}

        json = JSON.parse(response.body)

        expect(response).to have_http_status(422)
        expect(json['username']).to eq(["can't be blank"])
      end
    end
  end

  describe 'DELETE /comments', type: :request do
    it 'destroys the requested comment' do
      delete comment_url(id: @comment)

      json = JSON.parse(response.body)

      expect(response).to have_http_status(200)
      expect(json['deleted']).to eq(true)
    end

    it 'does not destroy the requested comment' do
      delete comment_url(id: 0)

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:unprocessable_entity)
      expect(json['deleted']).to eq(false)
    end
  end
end