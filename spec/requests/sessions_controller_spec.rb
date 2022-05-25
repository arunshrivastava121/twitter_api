require 'rails_helper'

RSpec.describe "/sessions", type: :request do
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

  let(:invalid_password) {
    {
      email: 'abc@gamil.com',
      password: '654321'
    }
  }

  before(:each) do
    @user = User.create! valid_user_attributes
  end

  context 'with valid parameters' do
    it 'create a new session' do
      post '/sessions', params: {user: valid_session_attributes}

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json['logged_in']).to eq(true)
      expect(session[:user_id]).to eq(User.last.id)
    end

    it 'passing invalid password' do
      post '/sessions', params: {user: invalid_password}

      json = JSON.parse(response.body)

      expect(response).to have_http_status(401)
      expect(json['error']).to eq("Invalid User")
      expect(session[:user_id]).to eq(nil)
    end
  end

  describe 'GET /logged_in', type: :request do
    it 'user should login in' do
      post '/sessions', params: {user: valid_session_attributes}
      get '/logged_in'

      json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(json['logged_in']).to eq(true)
      expect(session[:user_id]).to eq(User.last.id)
    end

    it "user shouldn't login in" do
      get '/logged_in'

      json = JSON.parse(response.body)

      expect(response).to have_http_status(401)
      expect(json['logged_in']).to eq(false)
      expect(session[:user_id]).to eq(nil)
    end
  end

  describe 'DELETE /logout', type: :request do
    it 'user should logout' do
      post '/sessions', params: {user: valid_session_attributes}
      get '/logged_in'

      login_json = JSON.parse(response.body)

      expect(login_json['logged_in']).to eq(true)
      expect(session[:user_id]).to eq(User.last.id)

      delete '/logout'

      logout_json = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(logout_json['logged_out']).to eq(true)
      expect(session[:user_id]).to eq(nil)
    end
  end
end