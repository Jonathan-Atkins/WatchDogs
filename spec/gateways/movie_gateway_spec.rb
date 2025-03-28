require 'rails_helper'

RSpec.describe MovieGateway do
  describe '.get_top_rated' do
    it 'returns an array of Movie objects', :vcr do
      response = MovieGateway.get_top_rated  

      expect(response).to be_a(Array)
      expect(response.first).to be_an(Movie)
      expect(response.first).to respond_to(:id, :title, :vote_average)
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
      response = MovieGateway.search_movies("NonExistentMovie")
      expect(response).to eq([])
    end
  end

  describe '.find_movie_details' do
    it 'returns one detailed Movie object', :vcr do
      response = MovieGateway.find_movie_details("27205")

      expect(response).to be_an(Movie)
      expect(response).to respond_to(:id, :title, :vote_average, :runtime, :genres, :summary, :cast)
      expect(response.runtime).to be_a(Integer).or be_nil
      expect(response.genres).to be_a(Array)
      expect(response.summary).to be_a(String).or be_nil
      expect(response.cast).to be_a(Array)
    end
  end
end