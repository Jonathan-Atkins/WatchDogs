require 'rails_helper'

RSpec.describe 'Create a Viewing Party', type: :request do
  describe 'POST /api/v1/viewing_parties' do
    let!(:host) { User.new(name: "Host User", username: "hostuser", password: "password") }
    let!(:invitee1) { User.new(name: "Invitee One", username: "invitee1", password: "password") }
    let!(:invitee2) { User.new(name: "Invitee Two", username: "invitee2", password: "password") }
    let(:valid_params) do
      {
        viewing_party: {
          name: "Movie Night",
          start_time: "2025-04-01T19:00:00Z",
          end_time: "2025-04-01T21:30:00Z",
          movie_id: 1,
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
        expect(json_response["data"]["attributes"]["name"]).to eq("Movie Night")
        expect(json_response["data"]["attributes"]["movie_title"]).to eq("Inception")
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