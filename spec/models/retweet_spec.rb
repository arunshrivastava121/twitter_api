require 'rails_helper'

RSpec.describe Retweet, type: :model do
  describe 'association' do
    it { should belong_to(:post).class_name('Post') }
  end

  describe 'validation' do
    it { should validate_presence_of(:user_id) }
  end
end