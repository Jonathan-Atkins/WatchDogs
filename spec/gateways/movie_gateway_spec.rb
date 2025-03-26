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

    it 'handles API errors gracefully', :vcr do
      allow(Faraday).to receive(:get).and_raise(Faraday::Error::TimeoutError)

      expect { MovieGateway.get_top_rated }.to raise_error(Faraday::Error::TimeoutError)
    end

    it 'handles unexpected data structures in the API response', :vcr do
      allow(MovieGateway).to receive(:parse_data).and_return([{"id" => "123", "title" => "Movie"}])

      response = MovieGateway.get_top_rated
      expect(response.first.id).to eq("123")
      expect(response.first.title).to eq("Movie")
    end
  end

  describe '.search_movies' do
    it 'returns an array of Movie objects based on search query', :vcr do
      response = MovieGateway.search_movies("Lord of the Rings")

      expect(response).to be_a(Array)
      expect(response.first).to be_an(Movie)
      expect(response.first).to respond_to(:id, :title, :vote_average)
    end

    it 'returns an empty array for a search query with no results', :vcr do
      allow(MovieGateway).to receive(:connect_to_gateway).and_return([])

      response = MovieGateway.search_movies("NonExistentMovie")
      expect(response).to eq([])
    end

    it 'handles a search API error gracefully', :vcr do
      allow(Faraday).to receive(:get).and_raise(Faraday::Error::ConnectionFailed)

      expect { MovieGateway.search_movies("Test") }.to raise_error(Faraday::Error::ConnectionFailed)
    end
  end
end