class Api::V1::MoviesController < ApplicationController
  def index
    begin
      if params[:query]
        results = MovieGateway.search_movies(params[:query])
        if results.empty?
          error_message = ErrorMessage.new("No movies found for your query.", 404)
          render json: ErrorSerializer.format_error(error_message), status: :not_found
        else 
          render json: MovieSerializer.new(results)
        end
      else
        top_rated = MovieGateway.get_top_rated
        if top_rated.empty?
          error_message = ErrorMessage.new("No top-rated movies available.", 404)
          render json: ErrorSerializer.format_error(error_message), status: :not_found
        else
          render json: MovieSerializer.new(top_rated)
        end
      end
    rescue StandardError => e
      render json: { error: "Failed to fetch movies: #{e.message}" }, status: 500
    end
  end

  def show
    movie = MovieGateway.find_movie_details(params[:id])
    require 'pry'; binding.pry
  end
end