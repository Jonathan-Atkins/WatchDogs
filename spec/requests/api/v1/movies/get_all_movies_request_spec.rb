require "rails_helper"

describe "Top Movies", type: :request do
  describe "GET /api/v1/movies" do
    context "when the request is successful (happy path)" do
      it "returns top-rated movies", :vcr do
        get "/api/v1/movies"

        expect(response).to be_successful
        expect(response.status).to eq(200)

        movies = JSON.parse(response.body, symbolize_names: true)[:data]
        expect(movies).to be_an(Array)
        expect(movies.count).to eq(20)

        movies.each do |movie|
          attrs = movie[:attributes]
          expect(movie[:id]).to be_an(String)
          expect(movie[:type]).to eq("movie")
          expect(attrs[:title]).to be_an(String)
          expect(attrs[:vote_average]).to be_an(Float)
        end
      end
    end

    context "when an error occurs (sad path)" do
      it "returns a 500 error with a failure message" do
        allow(MovieGateway).to receive(:get_top_rated).and_raise(StandardError, "Unexpected error")

        get "/api/v1/movies"

        expect(response.status).to eq(500)

        error_response = JSON.parse(response.body, symbolize_names: true)
        expect(error_response[:error]).to eq("Failed to fetch movies: Unexpected error")
      end
    end
  end
end