require 'rails_helper'

RSpec.describe 'Update a Viewing Party', type: :request do
  describe 'update a particular viewing party' do
    context 'Happy Path' do
      it 'updates a valid viewing party' do
        require 'pry'; binding.pry
        patch '/api/v1/viewing_parties', params: valid_params
        expect(response.status).to be 201
        json_response = JSON.parse(response.body)

        expect(ViewingParty.count).to eq 1
        expect(ViewingPartyUser.count).to eq 2
        expect(json_response["data"]["attributes"]["name"]).to eq("Movie Night")
        expect(json_response["data"]["attributes"]["movie_title"]).to eq("Inception")
        expect(json_response["data"]["relationships"]["users"]["data"].map { |user| user["id"] }).to eq([invitee1.id.to_s, invitee2.id.to_s])
      end
    end

    context 'Sad Path' do
      it 'returns an error if required fields are missing' do
        invalid_params = valid_params.except(:viewing_party)
        invalid_params[:viewing_party] = valid_params[:viewing_party].except(:movie_id)

        post '/api/v1/viewing_parties', params: invalid_params

        expect(response).not_to be_successful
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Movie can't be blank")
      end

      it 'returns an error if name is missing' do
        invalid_params = valid_params.except(:viewing_party)
        invalid_params[:viewing_party] = valid_params[:viewing_party].except(:name)

        post '/api/v1/viewing_parties', params: invalid_params

        expect(response).not_to be_successful
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Name can't be blank")
      end

      it 'returns an error if start_time is missing' do
        invalid_params = valid_params.except(:viewing_party)
        invalid_params[:viewing_party] = valid_params[:viewing_party].except(:start_time)

        post '/api/v1/viewing_parties', params: invalid_params

        expect(response).not_to be_successful
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Start time can't be blank")
      end

      it 'returns an error if end_time is missing' do
        invalid_params = valid_params.except(:viewing_party)
        invalid_params[:viewing_party] = valid_params[:viewing_party].except(:end_time)

        post '/api/v1/viewing_parties', params: invalid_params

        expect(response).not_to be_successful
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("End time can't be blank")
      end

      it 'returns an error if invitees are missing' do
        invalid_params = valid_params.except(:invitees)

        post '/api/v1/viewing_parties', params: invalid_params

        expect(response).not_to be_successful
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Invitees can't be blank")
      end
    end
  end
end