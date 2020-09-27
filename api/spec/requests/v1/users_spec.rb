require 'rails_helper'

describe 'users requests', type: :request do
  let(:user) { create :user }

  describe 'get /v1/profile' do

    context 'without headers' do
      it "returns unauthorized without proper headers" do
        get v1_profile_url, :headers => headers
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid headers' do

      subject do
        headers = { 'Authorization': TokenAuthority.issue_token_to_user(user) }
        get v1_profile_url, headers: headers
        response
      end

      describe 'response code' do
        example { expect(subject.response_code).to eq(200) }
      end

      describe 'response body' do
        example { expect(JSON.parse(subject.body)['email']).to eq(user.email) }
      end
    end
  end

  describe 'post /v1/user' do

    context 'post /v1/users with valid params' do

      subject do
        post v1_users_url, params: { user: { email: 'test@test.test', password: 'pw12345' } }
        response
      end

      describe 'response code' do
        example { expect(subject.response_code).to eq(200) }
      end

      describe 'response body' do
        example { expect(JSON.parse(subject.body)['auth_token']).not_to be_empty }
      end

      describe 'adds a user' do
        example { expect { subject }.to change { User.all.size }.by(1) }
      end
    end

    context 'post /v1/users with invalid email params' do

      subject do
        post v1_users_url, params: { user: { email: user.email, password: 'pw12345' } }
        response
      end

      describe 'response code when email repeated' do
        example { expect(subject.response_code).to eq(422) }
      end

      # TODO: think about changing this response
      describe 'response body when email repeated' do
        example { expect(JSON.parse(subject.body)['email']).to eq(["has already been taken"]) }
      end
    end

    context 'post /v1/users with invalid pw params' do

      subject do
        post v1_users_url, params: { user: { email: 'uniq@example.com', password: '' } }
        response
      end

      describe 'response code when pw is blank' do
        example { expect(subject.response_code).to eq(422) }
      end

      describe 'response body when pw is blank' do
        example { expect(JSON.parse(subject.body)['password']).to eq(["can't be blank"]) }
      end
    end
  end
end
