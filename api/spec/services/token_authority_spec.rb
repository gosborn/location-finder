require 'rails_helper'

RSpec.describe TokenAuthority, type: :request do
  let(:user) { create :user }

  subject do
    headers = { 'Authorization': TokenAuthority.issue_token_to_user(user) }
    get '/v1/profile', headers: headers
    response
  end

  it 'should be able to decode the user' do
    request = subject.request
    token_payload = TokenAuthority.decode_from_request(request)
    expect(token_payload.valid_user).to eq(user)
  end
end
