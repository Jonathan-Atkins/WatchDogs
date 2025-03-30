require 'rails_helper'

RSpec.describe 'Create a Viewing Party', type: :request do
  describe 'POST /api/v1/viewing_parties' do
    before(:each) do
      ViewingPartyUser.destroy_all
      ViewingParty.destroy_all
      User.destroy_all
    end

    let!(:host) { User.create(name: "Host User", username: "hostuser", password: "password") }
    let!(:invitee1) { User.create(name: "Invitee One", username: "invitee1", password: "password") }
    let!(:invitee2) { User.create(name: "Invitee Two", username: "invitee2", password: "password") }

    let(:valid_params) do
      {
        viewing_party: {
          name: "Movie Night",
          start_time: DateTime.now,
          end_time: DateTime.now + 4.hours,
          movie_id: 278,
          movie_title: "Inception",
          host_id: host.id
        },
        invitees: [invitee1.id, invitee2.id]
      }
    end

    context 'when the request is valid' do
      it 'creates a new viewing party and returns a success response' do 
        post '/api/v1/viewing_parties', params: valid_params
        expect(response).to be_successful
        json_response = JSON.parse(response.body)

        expect(ViewingParty.count).to eq 1
        expect(ViewingPartyUser.count).to eq 2
        expect(json_response["data"]["attributes"]["name"]).to eq("Movie Night")
        expect(json_response["data"]["attributes"]["movie_title"]).to eq("Inception")
        expect(json_response["data"]["relationships"]["users"]["data"].map { |user| user["id"] }).to eq([invitee1.id.to_s, invitee2.id.to_s])
      end
    end

    context 'when the request is invalid' do
      it 'returns an error if required fields are missing' do
        invalid_params = valid_params.dup
        invalid_params[:viewing_party][:name] = nil

        post '/api/v1/viewing_parties', params: invalid_params

        expect(response).to have_http_status(:unprocessable_entity)
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Name can't be blank")
      end
    end
  end
end