require 'rails_helper'

describe Visit, type: :model do
  describe 'status validation' do
    let(:user) { create :user }
    let(:location) { create :location }
    let(:near_visit) { create :visit, location: location, user: user }
    let(:far_visit) { create :visit, location: location, user: user, latitude: 10, longitude: 10 }
    let(:locationless_visit) { create :visit, location: location, user: user, latitude: nil, longitude: nil }

    it 'should validate near visits' do
      expect(near_visit.status).to eq('confirmed')
    end

    it 'should flag far away visits' do
      expect(far_visit.status).to eq('flagged')
    end

    it 'should leave visits pending without location information' do
      expect(locationless_visit.status).to eq('pending')
    end
  end
end
