require "rails_helper"

describe "A Movie Detail", type: :request do
  describe "show details of one movie" do
    context "Happy Paths" do
      it "returns details of a movie", :vcr do
        movie_id = 278
        get "/api/v1/movies/#{movie_id}"

        expect(response).to be_successful

      end
    end

    context "Sad Paths" do
      it "returns a 404 error when no movies match the search query" do

      end
    end
  end
end