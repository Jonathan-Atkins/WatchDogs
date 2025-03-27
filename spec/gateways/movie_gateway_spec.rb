require 'rails_helper'

RSpec.describe MovieGateway do
  describe '.get_top_rated' do
    it 'returns an array of Movie objects', :vcr do
      response = MovieGateway.get_top_rated  

      expect(response).to be_a(Array)
      expect(response.first).to be_an(Movie)
      expect(response.first).to respond_to(:id, :title, :vote_average)
    end

    it 'handles an empty API response gracefully', :vcr do
      allow(MovieGateway).to receive(:connect_to_gateway).and_return([])

      response = MovieGateway.get_top_rated
      expect(response).to eq([])
    end
  end

  describe '.search_movies' do
    it 'returns an array of Movie objects based on search query', :vcr do
      response = MovieGateway.search_movies("The Shawshank Redemption")

      expect(response).to be_a(Array)
      expect(response.first).to be_an(Movie)
      expect(response.first).to respond_to(:id, :title, :vote_average)
    end

    it 'returns an empty array for a search query with no results', :vcr do
      allow(MovieGateway).to receive(:connect_to_gateway).and_return([])

      response = MovieGateway.search_movies("NonExistentMovie")
      expect(response).to eq([])
    end
  end
end