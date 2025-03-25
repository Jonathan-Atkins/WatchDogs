require "rails_helper"

describe "Access All Movies", type: :request do
  it "returns all top-rated movies", :vcr do
    get "/api/v1/movies"
    expect(response).to be_successful
    expect(response.status).to eq 200

    movies = JSON.parse(response.body, symbolize_names: true)[:data]
    expect(movies).to be_an(Array)
    expect(movies.count).to eq 20
  end
end