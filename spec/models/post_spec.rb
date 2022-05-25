require 'rails_helper'

RSpec.describe Post, type: :model do
  describe 'associations' do
    it { should belong_to(:user).class_name('User') }
    it { should have_many(:comments) }
    it { should have_many(:retweets) }
  end

  describe 'validations' do
    it { should validate_presence_of(:text) }

    it 'validates presence' do
      record = Post.new
      record.text = nil # invalid state
      record.validate
      expect(record.errors[:text]).to include("can't be blank") # check for presence of error
  
      record.text = 'text' # valid state
      record.validate 
      expect(record.errors[:text]).to_not include("can't be blank") # check for absence of error
    end
  end
end