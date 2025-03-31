class MovieGateway 
  def self.get_top_rated
    movies = connect_to_gateway("/3/movie/top_rated")[:results]
    movies.map { |m| Movie.new(m) }
  end
  
  def self.search_movies(query)
    movies = connect_to_gateway("/3/search/movie", { query: query })[:results]
    movies.map { |m| Movie.new(m) }
  end

  def self.find_movie_details(movie_id)
    movie = connect_to_gateway("/3/movie/#{movie_id}")
    movie[:cast] = connect_to_gateway("/3/movie/#{movie_id}/credits")
    Movie.new(movie, detailed: true) unless movie[:success] == false
  end

  private

  def self.connect_to_gateway(endpoint, params = {})
    response = Faraday.new('https://api.themoviedb.org').get(endpoint) do |req|
      req.params = params
      req.params[:api_key] = Rails.application.credentials.tmdb[:key]
    end
    parse_data(response)
  end
  
  def self.parse_data(response)
    JSON.parse(response.body, symbolize_names: true)
  end
end