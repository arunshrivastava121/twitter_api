require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'associations' do
    it { should have_many(:posts) }
    it { should have_many(:comments) }
  end

  describe 'validation' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:password) }
    it { should allow_value('abc@gmail.com').for(:email) }
    it { should_not allow_value("foo").for(:email) }
    it { should have_secure_password }
    it { should validate_confirmation_of(:password) }

    it do
      should validate_length_of(:password).
        is_at_least(6).
        on(:create)
    end

    it do
      should validate_length_of(:password).
        is_at_least(6).
        on(:update)
    end
  end
end