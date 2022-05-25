require 'rails_helper'

RSpec.describe "/registrations", type: :request do
  let(:valid_attributes) {
    {
      name: 'xyz',
      email: 'xyz@gmail.com',
      password: '123456',
      password_confirmation: '123456'
    }
  }

  let(:invalid_attributes) {
    {
      name: 'xyz',
      email: '',
      password: '123456',
      password_confirmation: '123456'
    }  
  }

  context "with valid parameters" do
    it "creates a new User" do
      post registrations_url, params: { user: valid_attributes }

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(response).to have_http_status(:ok)
      expect(json[:user][:name]).to eq('xyz')
      expect(json[:user][:email]).to eq('xyz@gmail.com')
    end

    it "User should be one" do
      post registrations_url, params: { user: valid_attributes }

      expect(User.count).to eq(1)
      expect(User.last.email).to eq('xyz@gmail.com')
    end
  end

  context "with invalid parameters" do
    it "does not create a new User" do
      post registrations_url, params: { user: invalid_attributes }

      json = JSON.parse(response.body).deep_symbolize_keys

      expect(response.status).to eq(422)
      expect(json[:user][:email]).to eq(["is invalid"])
      expect(User.count).to eq(0)
    end
  end

end