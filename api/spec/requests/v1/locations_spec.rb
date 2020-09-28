require 'rails_helper'

describe 'locations requests', type: :request do
  let(:location) { create :location }

  describe 'get /v1/locations/{:id}' do

    context 'without headers' do
      it "returns unauthorized without proper headers" do
        get v1_location_url location.id
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'with valid headers' do
      let(:user) { create :user }

      subject do
        headers = { 'Authorization': TokenAuthority.issue_token_to_user(user) }
        get "/v1/locations/#{location.id}", headers: headers
        response
      end

      describe 'response code' do
        example { expect(subject.response_code).to eq(200) }
      end

      describe 'response body' do
        it 'should contain name, description, but not location info' do
          data = JSON.parse(subject.body)['data']['attributes']

          expect(data['name']).to eq(location.name)
          expect(data['description']).to eq(location.description)
          expect(data['longitude']).to be_nil
          expect(data['latitude']).to be_nil
        end
      end
    end
  end
end
