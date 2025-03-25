class Api::V1::MoviesController < ApplicationController
  def index
    top_movies = MovieGateway.get_top_rated
    render json: MovieSerializer.new(top_movies)
  end
end