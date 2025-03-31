require 'rails_helper'

RSpec.describe 'Update a Viewing Party', type: :request do
  describe 'update a particular viewing party' do
    before(:each) do
      ViewingPartyUser.destroy_all
      ViewingParty.destroy_all
      User.destroy_all
    end

    let!(:host) { User.create!(name: "Host User", username: "hostuser", password: "password") }
    let!(:invitee1) { User.create!(name: "Invitee One", username: "invitee1", password: "password") }
    let!(:invitee2) { User.create!(name: "Invitee Two", username: "invitee2", password: "password") }
    let!(:invitee3) { User.create!(name: "Invitee Three", username: "invitee3", password: "password") }

    let!(:viewing_party1) do 
      ViewingParty.create!(
        name: "Movie Night", 
        start_time: DateTime.now, 
        end_time: DateTime.now + 4.hours, 
        movie_id: 278, 
        movie_title: "Inception", 
        host_id: host.id
      )
    end

    let!(:viewing_party2) do 
      ViewingParty.create!(
        name: "Batman Night", 
        start_time: DateTime.now, 
        end_time: DateTime.now + 4.hours, 
        movie_id: 155, 
        movie_title: "The Dark Knight", 
        host_id: host.id
      )
    end

    let!(:viewing_party3) do 
      ViewingParty.create!(
        name: "Parasite Night", 
        start_time: DateTime.now, 
        end_time: DateTime.now + 4.hours, 
        movie_id: 496243, 
        movie_title: "Parasite", 
        host_id: host.id
      )
    end

    let(:update_params) do 
      {
        viewing_party: {
          name: "Updated Movie Night",
          movie_id: 238,
          movie_title: "The Godfather"
        },
        invitees: [invitee3.id] # Fix: should be an array
      }
    end

    context 'Happy Path' do
      it 'updates a valid viewing party' do
        patch "/api/v1/viewing_parties/#{viewing_party1.id}", params: update_params

        expect(response.status).to eq 200

        json_response = JSON.parse(response.body)
        expect(json_response["name"]).to eq("Updated Movie Night")
        expect(json_response["movie_id"]).to eq(238)
        expect(json_response["movie_title"]).to eq("The Godfather")
      end
    end

    context 'Sad Path' do
      xit 'returns an error if required fields are missing' do
      end
    end
  end
end