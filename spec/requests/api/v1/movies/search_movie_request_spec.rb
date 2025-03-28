require "rails_helper"

describe "Top Moives", type: :request do
  describe "GET search/movies" do
    context "Happy Paths" do
      it "returns movies matching the search query", :vcr do
        get "/api/v1/movies", params: { query: "Inception" }

        expect(response).to be_successful
        expect(response.status).to eq(200)

        movies = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(movies).to be_an(Array)
        expect(movies.count).to be > 0

        movies.each do |movie|
          require 'pry'; binding.pry
          attrs = movie[:attributes]
          expect(movie[:id]).to be_a(String)
          expect(movie[:type]).to eq("movie")
          expect(attrs[:title]).to be_a(String)
          expect(attrs[:vote_average]).to be_a(Float)
        end
      end
    end

    context "Sad Paths" do
      it "returns a 404 error when no movies match the search query" do
        allow(MovieGateway).to receive(:search_movies).with("nonexistent").and_return([])

        get "/api/v1/movies", params: { query: "nonexistent" }

        expect(response.status).to eq(404)

        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response[:message]).to eq("No movies found for your query.")
      end

      it "returns a 500 error when an unexpected error occurs" do
        allow(MovieGateway).to receive(:search_movies).and_raise(StandardError, "Unexpected error")

        get "/api/v1/movies", params: { query: "Inception" }

        expect(response.status).to eq(500)

        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response[:error]).to eq("Failed to fetch movies: Unexpected error")
      end
    end
  end
end