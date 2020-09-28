require 'rails_helper'

RSpec.describe TokenPayload, type: :model do

  describe 'validity' do

    it 'should be valid with defaults' do
      subject = TokenPayload.new TokenPayload.token_defaults
      expect(subject.error).to be_nil
    end

    it 'should be invalid with no payload' do
      subject = TokenPayload.new
      expect(subject.error).to eq(TokenPayload::VALIDATIONS[:issuer_incorrect?])
    end

    it 'should be invalid with incorrect issuer' do
      subject = TokenPayload.new TokenPayload.token_defaults.merge! issuer: 'different-app'
      expect(subject.error).to eq(TokenPayload::VALIDATIONS[:issuer_incorrect?])
    end

    it 'should be invalid with old expires_at' do
      subject = TokenPayload.new TokenPayload.token_defaults.merge! expires_at: 10.minutes.ago.to_i
      expect(subject.error).to eq(TokenPayload::VALIDATIONS[:expired?])
    end
  end

  describe 'new_for_user' do
    let(:user) { create :user }

    it 'should return hash with user info' do
      subject = TokenPayload.new_for_user(user)
      expect(subject[:user_id]).to eq(user.id)
    end
  end
end
