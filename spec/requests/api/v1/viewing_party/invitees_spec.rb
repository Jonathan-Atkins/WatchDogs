require 'rails_helper'

RSpec.describe 'Api::V1::InviteesController', type: :request do
  # Manually creating the user records
  let!(:user1) { User.create!(name: "Danny DeVito", username: "danny_de_v", password: "jerseyMikesRox7") }
  let!(:user2) { User.create!(name: "Dolly Parton", username: "dollyP", password: "Jolene123") }
  
  # Manually creating a viewing party
  let!(:viewing_party) { ViewingParty.create!(name: "Movie Night", start_time: DateTime.now, end_time: DateTime.now + 4.hours, movie_id: 278, movie_title: "Inception", host_id: user1.id) }

  # Ensure viewing party invitees exist if necessary
  before do
    ViewingPartyUser.create!(viewing_party_id: viewing_party.id, user_id: user2.id)
  end

  describe 'POST /api/v1/viewing_parties/:viewing_party_id/invitees' do
    context 'when the viewing party and user exist' do
      it 'adds the user as an invitee to the viewing party' do
        # Add the user as an invitee using the users association
        post "/api/v1/viewing_parties/#{viewing_party.id}/invitees", params: { invitees_user_id: user2.id }

        # Check the response
        expect(response).to have_http_status(:ok)
        expect(json['data']['attributes']['name']).to eq(viewing_party.name)
        expect(json['data']['relationships']['users']['data'].count).to eq(2) # Ensure the user is added
        expect(json['data']['relationships']['users']['data'].last['id']).to eq(user2.id.to_s)
      end
    end

    context 'when the viewing party does not exist' do
      it 'returns an error' do
        # Make the API request with a non-existent viewing party ID
        post '/api/v1/viewing_parties/999999/invitees', params: { invitees_user_id: user2.id }

        # Check the error response
        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq('Viewing party not found')
      end
    end

    context 'when the user does not exist' do
      it 'returns an error' do
        # Make the API request with a non-existent user ID
        post "/api/v1/viewing_parties/#{viewing_party.id}/invitees", params: { invitees_user_id: 999999 }

        # Check the error response
        expect(response).to have_http_status(:not_found)
        expect(json['error']).to eq('User not found')
      end
    end
  end
end